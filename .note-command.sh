# Set git username and email
git config --global user.name "Full Name"
git config --global user.email "email@address.com"
#####################

# Cache git credentials
git config --global credential.helper cache

git config --global credential.store
#####################

# Zip a folder
zip -r folder.zip ./folder
#####################

# Encrypt a file
zip -P "your_password" file.zip file.txt
#####################

# Decrypt a file
unzip -P "your_password" file.zip
#####################

#AES Encrypt
echo "Hello, World" | openssl enc -aes-256-cbc -base64 -pbkdf2 -salt -pass pass:yourpassword
#AES Decrypt
echo "U2FsdGVkX1+..." | openssl enc -aes-256-cbc -base64 -pbkdf2 -salt -d -pass pass:yourpassword
#####################

# Clear cached git credentials
git credential-cache exit
#####################

# Local port forwarding via SSH (example wirh local port is 33006, target ip is 192.168.0.2, remote port is 3306, proxy host is 192.168.0.1)
ssh -i ~/.ssh/id_rsa -L 33006:192.168.0.2:3306 username@192.168.0.1
#####################

#Passwordless sudo
echo "$USER ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers
#####################

# Set grub timeout to 0
sudo sed -i 's/GRUB_TIMEOUT=.*/GRUB_TIMEOUT=0/' /etc/default/grub
sudo update-grub
############

# Turn off swap
sudo swapoff -a
sudo cp -f /etc/fstab /etc/fstab.bak
sudo sed -e '/swap/ s/^#*/#/' -i /etc/fstab
#####################

#Check SAN domains
gnutls-cli www.valuemax.com.sg -p 443 --print-cert < /dev/null | certtool -i | grep -C3 -i dns
############

# Create a cerificate
openssl req -new -newkey rsa:2048 -days 365 -nodes -x509 -keyout domain.key -out domain.crt
#####################

# Confirm a certificate is signed by a specific CA using OpenSSL.
openssl verify -CAfile chain.pem certificate.crt
#####################

#Convert pfx
openssl pkcs12 -export -out certificate.pfx -inkey private-key.pem -in certificate.pem
#####################

# Instantly create a reverse porxy
mitmproxy --listen-port 8000 --mode reverse:https://example.com/path
#####################

# Block ping
sudo echo "net.ipv4.icmp_echo_ignore_all = 1" >> /etc/sysctl.conf 
sudo sysctl -p 
#####################

# Allow ip on port with xargs
cat allowed-ip.txt | xargs -I {} sudo ufw allow from {} to any port 80
#####################

# Make a new file from template file
sed -e "s/{{name}}/$NAME/g" -e "s/{{token}}/$TOKEN/g" template.yaml > target.yaml
#####################

# Destroy data on a drive
sudo dd if=/dev/zero of=/dev/sdX bs=4M status=progress
#####################

# Destroy data in parallel
cat drives.txt | parallel -j 0 sudo dd if=/dev/zero of=/dev/{} bs=4M status=progress
echo "sda\nsdb\nsdc" | parallel -j 0 sudo dd if=/dev/zero of=/dev/{} bs=4M status=progress
#####################

# Destroy data on a SSD
sudo hdparm --user-master u --security-set-pass p /dev/sdX
sudo hdparm --user-master u --security-erase p /dev/sdX
#####################

# Destroy data on a NVME
sudo nvme format /dev/nvmeXnY -s1
#####################

# Enable wake on LAN
sudo /usr/sbin ethtool -s enp7s0 wol g
#####################

# Listen if any usb device connected or disconnected
udevadm monitor --udev
#####################

# Get data from serial usb device
minicom -D /dev/ttyUSB0 -b 9600
#####################

# Create a partition
sudo fdisk /dev/sda
#####################

# Format the partiton
sudo mkfs.ext4 /dev/sdb1
#####################

# Mount a partion
sudo mkdir /mnt/sda1
sudo mount /dev/sda1 /mnt/sda1
#####################

# Add to fstab
echo "/dev/sdb1 /mnt/sdb1 ext4 defaults 0 0" | sudo tee -a /etc/fstab
#####################

#Incremental backup a diretory
# Full backup at first time, incremental backup at rest
rdiff-backup /source/path /backup/path
# List version
rdiff-backup --list-increments /backup/path
# Restore to a version
rdiff-backup -r "2025-01-08T18:07:35" /backup/path /restore/path
# Backup via ssh
rdiff-backup  -e "ssh -i /home/user/.ssh/id_rsa" ssh://user@remote_host//remote/source/directory /local/backup/directory

# Restore grub
# Identify Linux partition which is typically labeled "Linux Filesystem" (Example with sda1)
# Create a mount point directory (e.g., /mnt/linux).
sudo mkdir /mnt/linux
sudo mount /dev/sda1 /mnt/linux
sudo chroot /mnt/linux
#Reinstall GRUB
sudo grub-install --root-directory=/mnt/linux /dev/sda1
sudo update-grub
# Unmount and Reboot
sudo umount /mnt/linux
sudo reboot
