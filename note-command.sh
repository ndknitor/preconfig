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

# Create ISO file from current state of the system
sudo dd if=/dev/sdX of=/path/to/output.iso bs=4M status=progress
#####################
