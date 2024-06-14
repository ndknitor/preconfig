#!/bin/bash

USERNAME="user"
MASTER_IP="192.168.5.2"
SLAVE_IP="192.168.5.3"
DB_PASSWORD="your_database_password"

# Stop MySQL on both servers
ssh $USERNAME@$MASTER_IP 'sudo systemctl stop mysql'
ssh $USERNAME@$SLAVE_IP 'sudo systemctl stop mysql'

# Backup MySQL data on both servers (optional but recommended)
ssh $USERNAME@$MASTER_IP 'sudo cp -r /var/lib/mysql /var/lib/mysql_backup'
ssh $USERNAME@$SLAVE_IP 'sudo cp -r /var/lib/mysql /var/lib/mysql_backup'

# Get the current master info
CURRENT_MASTER=$(ssh $USERNAME@$MASTER_IP "mysql -u root -p'$DB_PASSWORD' -e 'SHOW MASTER STATUS\G'")
CURRENT_MASTER_LOG=$(echo "$CURRENT_MASTER" | grep File | awk '{print $2}')
CURRENT_MASTER_POS=$(echo "$CURRENT_MASTER" | grep Position | awk '{print $2}')

# Promote slave to master
ssh $USERNAME@$SLAVE_IP 'sudo sed -i "s/.*server-id.*/server-id = 1/g" /etc/mysql/mysql.conf.d/mysqld.cnf'
ssh $USERNAME@$SLAVE_IP 'sudo systemctl start mysql'

# Wait for MySQL server to start
sleep 10

# Get the new master info
NEW_MASTER_STATUS=$(ssh $USERNAME@$SLAVE_IP "mysql -u root -p'$DB_PASSWORD' -e 'SHOW MASTER STATUS\G'")
NEW_MASTER_LOG=$(echo "$NEW_MASTER_STATUS" | grep File | awk '{print $2}')
NEW_MASTER_POS=$(echo "$NEW_MASTER_STATUS" | grep Position | awk '{print $2}')

# Change old master to slave
ssh $USERNAME@$MASTER_IP "mysql -u root -p'$DB_PASSWORD' -e \"CHANGE MASTER TO MASTER_HOST='$SLAVE_IP', MASTER_USER='replication', MASTER_PASSWORD='$DB_PASSWORD', MASTER_LOG_FILE='$NEW_MASTER_LOG', MASTER_LOG_POS=$NEW_MASTER_POS;\""
ssh $USERNAME@$MASTER_IP "mysql -u root -p'$DB_PASSWORD' -e 'START SLAVE;'"

# Start MySQL on both servers
ssh $USERNAME@$MASTER_IP 'sudo systemctl start mysql'
ssh $USERNAME@$SLAVE_IP 'sudo systemctl start mysql'

# Check replication status
ssh $USERNAME@$MASTER_IP "mysql -u root -p'$DB_PASSWORD' -e 'SHOW SLAVE STATUS\G'"
