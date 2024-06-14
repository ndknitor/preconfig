#!/bin/bash

# Define variables
USERNAME="user"
SLAVE_IP="192.168.5.3"
DB_PASSWORD="your_database_password"
MASTER_IP="192.168.5.2"

# Install MySQL server if not already installed
sudo apt update
sudo apt install -y mysql-server

# Secure MySQL installation (optional but recommended)
sudo mysql_secure_installation

# Configure MySQL to listen on all interfaces
sudo sed -i 's/^\(bind-address\s*=\s*\)127\.0\.0\.1/\10.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf

# Restart MySQL service
sudo systemctl restart mysql

# Set up replication
mysql -u root -p"$DB_PASSWORD" -e "CHANGE MASTER TO MASTER_HOST='$MASTER_IP', MASTER_USER='replication', MASTER_PASSWORD='$DB_PASSWORD', MASTER_CONNECT_RETRY=10;"
mysql -u root -p"$DB_PASSWORD" -e "START SLAVE;"

# Check replication status
mysql -u root -p"$DB_PASSWORD" -e "SHOW SLAVE STATUS\G"
