from http.server import BaseHTTPRequestHandler, HTTPServer
import urllib.parse
import crypt

timezone = "Asia/Ho_Chi_Minh"
username = "kn"
password = "1"
public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAAgQDVqQbPFNqxA9+pMx5vGayek6KmDru+ZCKK+uckQVL0TRt7Tms6DdtRSyRovQdV8Ey4kBq3wYWyX/qWbq20V338f4qK8h/q3L3lkcxQEwtUYT6WVbW51ZEPmUs0sGrFjErvaaXEwAqlVz4K9PG3JBzgRp4WgytBddo42P+69gQXTQ== kn@ndkn"
netmask = "255.255.255.0"
gateway = "192.168.5.1"

class PreseedRequestHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        # Parse query parameters
        parsed_path = urllib.parse.urlparse(self.path)
        query_params = urllib.parse.parse_qs(parsed_path.query)

        # Extract hostname and IP address
        hostname = query_params.get('hostname', [''])[0].split('/')[0]
        if not hostname:
            self.send_response(400)
            self.end_headers()
            self.wfile.write(b'Missing hostname or ip parameters')
        hash = crypt.crypt(password, crypt.METHOD_SHA512)
        # Generate the preseed content
        preseed_content = f"""### Localization
# Preseeding only locale sets language, country and locale.
d-i debian-installer/locale string en_US.UTF-8
d-i debian-installer/language string en
d-i debian-installer/country string US

# Keyboard selection.
d-i keyboard-configuration/xkb-keymap select us

#Setting the timezone
d-i clock-setup/utc boolean true
d-i clock-setup/ntp boolean true
d-i time/zone string {timezone}

#Hostname
d-i netcfg/get_hostname string {hostname}
d-i netcfg/get_domain string unassigned-domain
d-i netcfg/wireless_wep string
d-i mirror/country string manual
d-i mirror/http/hostname string http.us.debian.org
d-i mirror/http/directory string /debian
d-i mirror/http/proxy string


#Configure users
d-i passwd/root-login boolean false
d-i passwd/user-fullname string {username}
d-i passwd/username string {username}
d-i passwd/user-password-crypted password {hash}


#Configure the network
d-i netcfg/choose_interface select auto
# Static network configuration.

#Partitioning
d-i partman-auto/method string lvm
d-i partman-lvm/device_remove_lvm boolean true
d-i partman-lvm/confirm boolean true
d-i partman-lvm/confirm_nooverwrite boolean true
d-i partman-auto/choose_recipe select atomic
d-i partman-auto-lvm/guided_size string max
d-i partman-md/device_remove_md boolean true
d-i partman-md/confirm boolean true


d-i partman-partitioning/confirm_write_new_label boolean true
d-i partman/choose_partition select finish
d-i partman/confirm boolean true
d-i partman/confirm_nooverwrite boolean true


#Package selection
tasksel tasksel/first multiselect
d-i pkgsel/include string openssh-server


#Disable send stats
popularity-contest popularity-contest/participate boolean false


# Choose, if you want to scan additional installation media
# (default: false).
d-i apt-setup/cdrom/set-first boolean false
d-i apt-setup/cdrom/set-next boolean false
d-i apt-setup/cdrom/set-failed boolean false


#GRUB configuration
d-i grub-installer/only_debian boolean true
d-i grub-installer/with_other_os boolean true
d-i grub-installer/bootdev  string default


# Late command to set GRUB timeout to 0
d-i preseed/late_command string \\
    in-target sed -i 's/GRUB_TIMEOUT=[0-9]*/GRUB_TIMEOUT=0/' /etc/default/grub; \\
    in-target update-grub; \\
    in-target mkdir -p /home/{username}/.ssh; \\
    in-target /bin/bash -c "echo '{public_key}' > /home/{username}/.ssh/authorized_keys"; \\
    in-target chown -R {username}:{username} /home/{username}/.ssh; \\
    in-target chmod 600 /home/{username}/.ssh/authorized_keys; \\
    in-target /bin/bash -c 'echo {hostname} > /etc/hostname'
d-i finish-install/reboot_in_progress note
"""
        print(preseed_content)
        # Send response
        self.send_response(200)
        self.send_header('Content-Type', 'text/plain')
        self.end_headers()
        self.wfile.write(preseed_content.encode())

def run(server_class=HTTPServer, handler_class=PreseedRequestHandler, port=8000):
    server_address = ('', port)
    httpd = server_class(server_address, handler_class)
    print(f'Starting httpd server on port {port}')
    httpd.serve_forever()

if __name__ == "__main__":
    run()
