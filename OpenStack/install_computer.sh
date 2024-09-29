#!/bin/bash

# Variables
CONTROLLER_IP="192.168.0.10" # Adjust to your controller IP
COMPUTE_IP=$(hostname -I | awk '{print $1}')
RABBIT_PASS="your_rabbitmq_password"
KEYSTONE_PASS="your_keystone_db_password"
GLANCE_PASS="your_glance_password"
ADMIN_PASS="your_admin_password"

# Update and install dependencies
apt update
apt -y upgrade
apt install -y python3-openstackclient nova-compute

# Install necessary drivers (e.g., KVM)
apt install -y qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils

# Enable and start libvirt service
systemctl enable libvirtd
systemctl start libvirtd

# Configure Nova to use the Controller
cat <<EOF > /etc/nova/nova.conf
[DEFAULT]
transport_url = rabbit://openstack:$RABBIT_PASS@$CONTROLLER_IP
auth_strategy = keystone
my_ip = $COMPUTE_IP
enabled_apis = osapi_compute,metadata
glance_host = $CONTROLLER_IP
[keystone_authtoken]
www_authenticate_uri = http://$CONTROLLER_IP:5000
auth_url = http://$CONTROLLER_IP:5000
memcached_servers = $CONTROLLER_IP:11211
auth_type = password
project_domain_name = Default
user_domain_name = Default
project_name = service
username = nova
password = your_nova_password
[vnc]
enabled = true
vncserver_listen = $COMPUTE_IP
vncserver_proxyclient_address = $COMPUTE_IP
[glance]
api_servers = http://$CONTROLLER_IP:9292
EOF

# Sync Nova Database
su -s /bin/sh -c "nova-manage cell_v2 discover_hosts --verbose" nova

# Restart Nova services
systemctl restart nova-compute

echo "OpenStack Compute setup complete on $COMPUTE_IP"
