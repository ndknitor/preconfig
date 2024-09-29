#!/bin/bash

# Variables
CONTROLLER_IPS=("192.168.0.10" "192.168.0.11" "192.168.0.12")
MY_IP=$(hostname -I | awk '{print $1}')
CLUSTER_NAME="openstack-cluster"
MYSQL_ROOT_PASS="your_mysql_root_password"
RABBIT_PASS="your_rabbitmq_password"
KEYSTONE_DB_PASS="your_keystone_db_password"
ADMIN_PASS="your_admin_password"
GLANCE_DB_PASS="your_glance_db_password"

# Disable UFW if running
ufw disable

# Update and install dependencies
apt update
apt -y upgrade
apt install -y python3-openstackclient mariadb-server python3-pymysql \
    rabbitmq-server memcached python3-memcache \
    etcd keystone glance

# Configure MySQL (Galera) Cluster
cat <<EOF > /etc/mysql/mariadb.conf.d/99-openstack.cnf
[mysqld]
bind-address = 0.0.0.0
default-storage-engine = innodb
innodb_file_per_table = on
max_connections = 4096
collation-server = utf8_general_ci
character-set-server = utf8
[galera]
wsrep_on = ON
wsrep_provider = /usr/lib/galera/libgalera_smm.so
wsrep_cluster_name = "$CLUSTER_NAME"
wsrep_cluster_address = "gcomm://${CONTROLLER_IPS[*]}"
wsrep_node_name = "$MY_IP"
wsrep_node_address = "$MY_IP"
wsrep_sst_method = rsync
EOF

# Restart MySQL service
systemctl restart mysql
mysql_secure_installation

# Create MySQL root user
mysql -u root -p"$MYSQL_ROOT_PASS" <<-EOF
CREATE USER 'root'@'%' IDENTIFIED BY '$MYSQL_ROOT_PASS';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%';
FLUSH PRIVILEGES;
EOF

# Configure RabbitMQ for HA
rabbitmqctl add_user openstack $RABBIT_PASS
rabbitmqctl set_permissions openstack ".*" ".*" ".*"

# Configure Keystone
mysql -u root -p"$MYSQL_ROOT_PASS" <<-EOF
CREATE DATABASE keystone;
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' IDENTIFIED BY '$KEYSTONE_DB_PASS';
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' IDENTIFIED BY '$KEYSTONE_DB_PASS';
FLUSH PRIVILEGES;
EOF

cat <<EOF > /etc/keystone/keystone.conf
[database]
connection = mysql+pymysql://keystone:$KEYSTONE_DB_PASS@controller/keystone
[token]
provider = fernet
EOF

# Populate Keystone Database
su -s /bin/sh -c "keystone-manage db_sync" keystone

# Initialize Fernet keys
keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone
keystone-manage credential_setup --keystone-user keystone --keystone-group keystone

# Bootstrap Keystone
keystone-manage bootstrap --bootstrap-password $ADMIN_PASS \
  --bootstrap-admin-url http://$MY_IP:5000/v3/ \
  --bootstrap-internal-url http://$MY_IP:5000/v3/ \
  --bootstrap-public-url http://$MY_IP:5000/v3/ \
  --bootstrap-region-id RegionOne

# Configure Apache for Keystone
echo "ServerName controller" >> /etc/apache2/apache2.conf
service apache2 restart

# Create Glance database
mysql -u root -p"$MYSQL_ROOT_PASS" <<-EOF
CREATE DATABASE glance;
GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'localhost' IDENTIFIED BY '$GLANCE_DB_PASS';
GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'%' IDENTIFIED BY '$GLANCE_DB_PASS';
FLUSH PRIVILEGES;
EOF

# Glance configuration
cat <<EOF > /etc/glance/glance-api.conf
[database]
connection = mysql+pymysql://glance:$GLANCE_DB_PASS@controller/glance
[keystone_authtoken]
www_authenticate_uri = http://controller:5000
auth_url = http://controller:5000
memcached_servers = controller:11211
auth_type = password
project_domain_name = Default
user_domain_name = Default
project_name = service
username = glance
password = your_glance_password
[glance_store]
stores = file,http
default_store = file
filesystem_store_datadir = /var/lib/glance/images/
EOF

# Sync Glance DB and restart service
su -s /bin/sh -c "glance-manage db_sync" glance
service glance-api restart

echo "Controller setup complete on $MY_IP"
