URL="https://google.com"
SSH_PUBLICKEY=""
SSH_USER=$1


if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root."
  exit 1
fi

mkdir -p /home/$SSH_USER/.ssh
echo $SSH_PUBLIC_KEY >> /home/$SSH_USER/.ssh/authorized_keys

apt update
apt upgrade
apt install openbox lightdm openssh-server unclutter wget -y
wget https://github.com/IMAGINARY/kiosk-browser/releases/download/v0.17.0/kiosk-browser_0.17.0_amd64.deb
apt install ./kiosk-browser_0.17.0_amd64.deb
rm kiosk-browser_0.17.0_amd64.deb

mkdir -p /home/kiosk/.config/openbox
groupadd kiosk
id -u kiosk &>/dev/null || useradd -m kiosk -g kiosk -s /bin/bash
chown -R kiosk:kiosk /home/kiosk

# remove virtual consoles
if [ -e "/etc/X11/xorg.conf" ]; then
  mv /etc/X11/xorg.conf /etc/X11/xorg.conf.backup
fi
cat > /etc/X11/xorg.conf << EOF
Section "ServerFlags"
    Option "DontVTSwitch" "true"
EndSection
EOF

# create config
if [ -e "/etc/lightdm/lightdm.conf" ]; then
  mv /etc/lightdm/lightdm.conf /etc/lightdm/lightdm.conf.backup
fi
cat > /etc/lightdm/lightdm.conf << EOF
[SeatDefaults]
autologin-user=kiosk
user-session=openbox
EOF


if [ -e "/home/kiosk/.config/openbox/autostart" ]; then
  mv /home/kiosk/.config/openbox/autostart /home/kiosk/.config/openbox/autostart.backup
fi

cat > /home/kiosk/.config/openbox/autostart << EOF
#!/bin/bash
xset s noblank
xset s off
xset -dpms

xmodmap -e "keycode 64 = "
xmodmap -e "keycode 108 = "
xmodmap -e "keycode 133 = "
#xmodmap -e "keycode 23 = "

unclutter -idle 1 -root &

sleep 20
while true; do
    until kiosk-browser $URL --kiosk; do
        echo "Browser exited"
    done
done
EOF

sed -i 's/GRUB_TIMEOUT=.*/GRUB_TIMEOUT=0/' /etc/default/grub
echo 'GRUB_BACKGROUND=""' >> /etc/default/grub
update-grub
reboot
