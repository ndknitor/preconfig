#!/bin/bash

# Define variables
USERNAME="user"
MASTER_IP="192.168.5.2"
DB_PASSWORD="your_database_password"

# Install MySQL server if not already installed
sudo apt update
sudo apt install -y mysql-server

# Secure MySQL installation (optional but recommended)
sudo mysql_secure_installation

# Configure MySQL to listen on all interfaces
sudo sed -i 's/^\(bind-address\s*=\s*\)127\.0\.0\.1/\10.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf

# Restart MySQL service
sudo systemctl restart mysql

# Create replication user
mysql -u root -p"$DB_PASSWORD" -e "CREATE USER 'replication'@'%' IDENTIFIED BY '$DB_PASSWORD';"
mysql -u root -p"$DB_PASSWORD" -e "GRANT REPLICATION SLAVE ON *.* TO 'replication'@'%';"
mysql -u root -p"$DB_PASSWORD" -e "FLUSH PRIVILEGES;"

# Get current master status
CURRENT_MASTER_STATUS=$(mysql -u root -p"$DB_PASSWORD" -e "SHOW MASTER STATUS\G")
CURRENT_MASTER_LOG=$(echo "$CURRENT_MASTER_STATUS" | grep File | awk '{print $2}')
CURRENT_MASTER_POS=$(echo "$CURRENT_MASTER_STATUS" | grep Position | awk '{print $2}')

# Output current master status
echo "Current master log file: $CURRENT_MASTER_LOG"
echo "Current master log position: $CURRENT_MASTER_POS"
