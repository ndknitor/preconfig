# curl https://raw.githubusercontent.com/ndknitor/preconfig/main/install.sh | bash

# Update
sudo apt update
sudo apt -y upgrade

#Install Software
sudo apt install -y net-tools python3 apt-transport-https ca-certificates curl gnupg lsb-release nodejs npm wget remmina ktorrent git chromium wireshark default-jdk nmap clusterssh timeshift ibus-unikey plank qt5-style-kvantum flameshot
sudo apt install -y gimp obs-studio kdenlive darktable

# Qt theme: https://www.gnome-look.org/p/1338881/
# Wallpaper: https://www.wallpaperflare.com/milkyway-earth-hd-wallpaper-uvdce

#Install nodejs packages
sudo npm install -g n yarn
sudo n stable

#Install Bun
# curl -fsSL https://bun.sh/install | bash

#Install Virtualbox
wget https://download.virtualbox.org/virtualbox/7.0.14/virtualbox-7.0_7.0.14-161095~Debian~bookworm_amd64.deb
sudo dpkg -i virtualbox*
rm virtualbox*

#Install Only Office
#wget https://download.onlyoffice.com/install/desktop/editors/linux/onlyoffice-desktopeditors_amd64.deb
#sudo dpkg -i onlyoffice*
#rm onlyoffice*

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

#Install Azure Data Studio
wget https://sqlopsbuilds.azureedge.net/stable/ba29842b81dec01177415e53948ca2168e69c3f8/azuredatastudio-linux-1.46.1.deb
#sudo apt install -y libunwind8
sudo dpkg -i azuredatastudio*
rm azuredatastudio*

#Install VSCode
wget https://az764295.vo.msecnd.net/stable/f1b07bd25dfad64b0167beb15359ae573aecd2cc/code_1.83.1-1696982868_amd64.deb
sudo dpkg -i code_*
rm code_*

#Install Trivy
sudo apt-get install wget apt-transport-https gnupg lsb-release
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | gpg --dearmor | sudo tee /usr/share/keyrings/trivy.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" | sudo tee -a /etc/apt/sources.list.d/trivy.list
sudo apt-get update
sudo apt-get install trivy

#Install Minikube
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb
sudo dpkg -i minikube_latest_amd64.deb
rm minikube*

#Install Tesseract
sudo apt install -y tesseract-ocr
mkdir -p $HOME/.local/share
git clone https://github.com/tesseract-ocr/tessdata.git $HOME/.local/share

#Install apt-fast
sudo apt-get install -y aria2
sudo wget https://raw.githubusercontent.com/ilikenwf/apt-fast/master/apt-fast -O /usr/bin/apt-fast
sudo chmod +x /usr/bin/apt-fast

#Install Docker
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
sudo usermod -aG docker ${USER}
sudo reboot
