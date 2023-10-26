# Update
sudo apt update
sudo apt -y upgrade
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
#Install Software
sudo apt install -y net-tools python3 nodejs wget gimp remmina obs-studio ktorrent git chromium firefox kdenlive wireshark virtualbox default-jdk nmap clusterssh

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
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
sudo usermod -aG docker ${USER}

#Helper bash
echo '
export PATH="$PATH:/sbin"
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools

alias dolroot="pkexec env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY KDE_SESSION_VERSION=5 KDE_FULL_SESSION=true dolphin"
alias bettercap="docker run --rm -it --privileged --net=host bettercap/bettercap"
alias photorec="sudo /home/kn/.local/share/testdisk/photorec_static"
alias android-emulator="/home/kn/Android/Sdk/emulator/emulator -avd Resizable_Experimental_API_34 </dev/null &> /dev/null & disown"

ranstr() {
    local length=${1:-32}
    if [[ $length -le 0 ]]; then
        echo "Error: Length should be a positive integer."
        return 1
    fi

    local characters="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local string=""

    for (( i=0; i<$length; i++ )); do
        local random_index=$(( RANDOM % ${#characters} ))
        local random_char=${characters:$random_index:1}
        string="$string$random_char"
    done

    echo "$string"
}
repo-fix(){
        for KEY in $( \
        apt-key list \
        | grep -E "(([ ]{1,2}(([0-9A-F]{4}))){10})" \
        | tr -d " " \
        | grep -E "([0-9A-F]){8}\b" \
        ); do
        K=${KEY:(-8)}
        apt-key export $K \
        | sudo gpg --dearmour -o /etc/apt/trusted.gpg.d/imported-from-trusted-gpg-$K.gpg
        done
}
' >> .bashrc
