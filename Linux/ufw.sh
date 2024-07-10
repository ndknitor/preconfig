# Default deny all
sudo ufw default deny incoming
sudo ufw default deny outgoing

# Default allow all
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Allow all on port 80
sudo ufw allow 80/tcp

# Deny all on port 80
sudo ufw deny 80

# Allow a subnet on port 80
sudo ufw allow from 192.168.1.0/24 to any port 80

# Deny a subnet on port 80
sudo ufw deny from 192.168.1.0/24 to any port 80

# Allow ip on port with xargs
cat allowed-ip.txt | xargs -I {} sudo ufw allow from {} to any port 80
