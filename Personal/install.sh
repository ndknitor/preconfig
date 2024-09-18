# curl https://raw.githubusercontent.com/ndknitor/preconfig/main/install.sh | bash


# Qt theme: https://www.gnome-look.org/p/1338881/
# Wallpaper: https://www.wallpaperflare.com/milkyway-earth-hd-wallpaper-uvdce

# Update
sudo apt update
sudo apt -y upgrade

#Install Software
sudo apt install -y \
net-tools network-manager-openvpn python3-pygments nfs-common nfs-kernel-server \
python3 apt-transport-https ca-certificates curl gnupg lsb-release nodejs npm wget \
remmina ktorrent git chromium wireshark nmap clusterssh timeshift ibus-unikey plank npm \ 
qt5-style-kvantum flameshot zenity

sudo apt install -y krita obs-studio kdenlive darktable

#Install nodejs packages
sudo npm install -g n yarn
sudo n stable

#Install Bun
curl -fsSL https://bun.sh/install | bash

#Install Trivy
sudo apt-get install wget apt-transport-https gnupg lsb-release
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | gpg --dearmor | sudo tee /usr/share/keyrings/trivy.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" | sudo tee -a /etc/apt/sources.list.d/trivy.list
sudo apt-get update
sudo apt-get install -y trivy

#Install Terraform
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install -y terraform

#Install Vagrant
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install -y vagrant

#Install dotnet
wget https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb
sudo apt-get update 
sudo apt-get install -y dotnet-sdk-8.0

#Install KVM
sudo apt-get install -y libvirt-clients libvirt-daemon-system qemu-kvm bridge-utils dnsmasq
sudo usermod -a -G libvirt $USER
sudo sed -i '/^# uri_default = "qemu:\/\/\/system"/s/^# //' /etc/libvirt/libvirt.conf
sudo apt install -y virt-manager

#Install apt-fast
#sudo apt-get install -y aria2
#sudo wget https://raw.githubusercontent.com/ilikenwf/apt-fast/master/apt-fast -O /usr/bin/apt-fast
#sudo chmod +x /usr/bin/apt-fast

#Install Docker
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
sudo usermod -aG docker ${USER}

#Install kubectl
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo chmod 644 /etc/apt/sources.list.d/kubernetes.list 
sudo apt-get update
sudo apt-get install -y kubectl

#Install Tesseract
sudo apt install -y tesseract-ocr
mkdir -p $HOME/.local/share/tessdata
wget -P $HOME/.local/share/tessdata https://github.com/tesseract-ocr/tessdata/raw/main/vie.traineddata
wget -P $HOME/.local/share/tessdata https://github.com/tesseract-ocr/tessdata/raw/main/eng.traineddata
wget -P $HOME/.local/share/tessdata https://github.com/tesseract-ocr/tessdata/raw/main/script/Vietnamese.traineddata

#Install Virtualbox
wget https://download.virtualbox.org/virtualbox/7.0.18/virtualbox-7.0_7.0.18-162988~Debian~bookworm_amd64.deb
sudo dpkg -i virtualbox*
rm virtualbox*

#Install Only Office
#wget https://download.onlyoffice.com/install/desktop/editors/linux/onlyoffice-desktopeditors_amd64.deb
#sudo dpkg -i onlyoffice*
#rm onlyoffice*

#Install Azure Data Studio
#wget https://sqlopsbuilds.azureedge.net/stable/ba29842b81dec01177415e53948ca2168e69c3f8/azuredatastudio-linux-1.46.1.deb
#sudo apt install -y libunwind8
#sudo dpkg -i azuredatastudio*
#rm azuredatastudio*

#Install VSCode
#wget https://az764295.vo.msecnd.net/stable/f1b07bd25dfad64b0167beb15359ae573aecd2cc/code_1.83.1-1696982868_amd64.deb
#sudo dpkg -i code_*
#rm code_*

#Install Minikube
#curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb
#sudo dpkg -i minikube_latest_amd64.deb
#rm minikube*

wget -P $HOME/.local/share/scripts https://raw.githubusercontent.com/ndknitor/preconfig/main/Personal/flameshot-ocr.sh
chmod +x $HOME/.local/share/scripts/flameshot-ocr.sh

wget -P $HOME/.local/share/scripts https://raw.githubusercontent.com/ndknitor/preconfig/main/Personal/colorpicker.sh
chmod +x $HOME/.local/share/scripts/colorpicker.sh

sudo reboot
