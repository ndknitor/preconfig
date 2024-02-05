# Update
sudo apt update
sudo apt -y upgrade

#Install Software
sudo apt install -y net-tools python3 apt-transport-https ca-certificates curl gnupg lsb-release nodejs wget remmina ktorrent git chromium firefox wireshark virtualbox default-jdk nmap clusterssh timeshift ibus-unikey latte-dock qt5-style-kvantum
sudo apt install -y gimp obs-studio kdenlive darktable

# Qt theme: https://www.gnome-look.org/p/1338881/
# Wallpaper: https://www.wallpaperflare.com/milkyway-earth-hd-wallpaper-uvdce

#Install nodejs packages
sudo npm install -g n yarn
sudo n stable

#Install Bun
curl -fsSL https://bun.sh/install | bash

#Install Only Office
wget https://download.onlyoffice.com/install/desktop/editors/linux/onlyoffice-desktopeditors_amd64.deb
sudo dpkg -i onlyoffice*
rm onlyoffice*

#Install Vagrant
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install -y vagrant

#Install dotnet
wget https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb
sudo apt-get update 
sudo apt-get install -y dotnet-sdk-6.0

#Install Azure Data Studio
wget https://sqlopsbuilds.azureedge.net/stable/ba29842b81dec01177415e53948ca2168e69c3f8/azuredatastudio-linux-1.46.1.deb
#sudo apt install -y libunwind8
sudo dpkg -i azuredatastudio*
rm azuredatastudio*

#Install VSCode
wget https://az764295.vo.msecnd.net/stable/f1b07bd25dfad64b0167beb15359ae573aecd2cc/code_1.83.1-1696982868_amd64.deb
sudo dpkg -i code_*
rm code_*

#Install Docker
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
sudo usermod -aG docker ${USER}

#Install Minikube
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb
sudo dpkg -i minikube_latest_amd64.deb
rm minikube*

#Install Tesseract
sudo apt install tesseract-ocr
mkdir -p $HOME/.local/share
git clone https://github.com/tesseract-ocr/tessdata.git $HOME/.local/share

#Install apt-fast
sudo apt-get install aria2
sudo wget https://raw.githubusercontent.com/ilikenwf/apt-fast/master/apt-fast -O /usr/bin/apt-fast
sudo chmod +x /usr/bin/apt-fast
