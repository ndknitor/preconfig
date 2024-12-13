# Create a cerificate
openssl req -new -newkey rsa:2048 -days 365 -nodes -x509 -keyout domain.key -out domain.crt
#####################

# Confirm a certificate is signed by a specific CA using OpenSSL.
openssl verify -CAfile chain.pem certificate.crt
#####################

#Convert pfx
openssl pkcs12 -export -out certificate.pfx -inkey private-key.pem -in certificate.pem
#####################

# Set git username and email
git config --global user.name "Full Name"
git config --global user.email "email@address.com"
#####################

# Cache git credentials
 git config --global credential.store
#####################

# Clear cached git credentials
git credential-cache exit
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

# Turn off swap
sudo swapoff -a
sudo cp -f /etc/fstab /etc/fstab.bak
sudo sed -e '/swap/ s/^#*/#/' -i /etc/fstab
#####################

# Make a new file from template file
sed -e "s/{{name}}/$NAME/g" -e "s/{{token}}/$TOKEN/g" template.yaml > target.yaml
#####################

#Passwordless sudo
echo "$USER ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers
#####################

# Set grub timeout to 0
sudo sed -i 's/GRUB_TIMEOUT=.*/GRUB_TIMEOUT=0/' /etc/default/grub
sudo update-grub
############

# Destroy data on a drive
sudo dd if=/dev/zero of=/dev/sdX bs=4M status=progress
#####################

# Destroy data in parallel
cat drives.txt | parallel -j 0 sudo dd if=/dev/zero of=/dev/{} bs=4M status=progress
echo "sda\nsdb\nsdc" | parallel -j 0 sudo dd if=/dev/zero of=/dev/{} bs=4M status=progress
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
