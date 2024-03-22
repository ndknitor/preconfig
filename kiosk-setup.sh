$URL="https://google.com"
$SSH_PUBLICKEY=""

apt update
apt upgrade
apt install chromium openbox lightdm -y
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
sleep 5

xmodmap -e "keycode 64 = "
xmodmap -e "keycode 108 = "
xmodmap -e "keycode 133 = "
xmodmap -e "keycode 23 = "

unclutter -idle 1 -root &
while true; do
    until chromium $URL --no-first-run --noerrdialogs --start-maximized --disable --disable-translate --disable-infobars --disable-suggestions-service --disable-save-password-bubble --disable-session-crashed-bubble --incognito --kiosk; do
        echo "Browser exited"
    done
done

EOF

echo $SSH_PUBLIC_KEY >> /root/.ssh/authorized_keys

echo "Done!"
