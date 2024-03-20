# Create a cerificate
openssl req -new -newkey rsa:2048 -days 365 -nodes -x509 -keyout domain.key -out domain.crt
#####################

# Cache git credentials
git config --global credential.helper "cache --timeout=999999999"
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

# Set grub timeout
sudo sed -i 's/GRUB_TIMEOUT=.*/GRUB_TIMEOUT=0/' /etc/default/grub
sudo update-grub
############

# Create ISO file from current state of the system
sudo dd if=/dev/sdX of=/path/to/output.iso bs=4M status=progress
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
