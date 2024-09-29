#!/bin/bash

# Variables
CONTROLLER_IP="192.168.0.10" # Adjust to your controller IP
STORAGE_IP=$(hostname -I | awk '{print $1}')
MYSQL_PASS="your_mysql_root_password"
CINDER_PASS="your_cinder_password"

# Update and install dependencies
apt update
apt -y upgrade
apt install -y python3-openstackclient cinder-volume

# Configure Cinder to use the Controller
cat <<EOF > /etc/cinder/cinder.conf
[DEFAULT]
transport_url = rabbit://openstack:your_rabbitmq_password@$CONTROLLER_IP
auth_strategy = keystone
my_ip = $STORAGE_IP
enabled_backends = lvm
[database]
connection = mysql+pymysql://cinder:$CINDER_PASS@$CONTROLLER_IP/cinder
[keystone_authtoken]
www_authenticate_uri = http://$CONTROLLER_IP:5000
auth_url = http://$CONTROLLER_IP:5000
memcached_servers = $CONTROLLER_IP:11211
auth_type = password
project_domain_name = Default
user_domain_name = Default
project_name = service
username = cinder
password = $CINDER_PASS
[lvm]
volume_driver = cinder.volume.drivers.lvm.LVMVolumeDriver
volume_group = cinder-volumes
EOF

# Create a volume group for Cinder
pvcreate /dev/sdb # Replace with your actual device
vgcreate cinder-volumes /dev/sdb # Replace with your actual device

# Sync Cinder Database
su -s /bin/sh -c "cinder-manage db sync" cinder

# Restart Cinder services
systemctl restart cinder-volume

echo "OpenStack Block Storage setup complete on $STORAGE_IP"
