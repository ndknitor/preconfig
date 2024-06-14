export DOTNET_CLI_TELEMETRY_OPTOUT=1
export TESSDATA_PREFIX="$HOME/.local/share/tessdata"
export PATH="$PATH:/sbin"
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools

alias sudo="sudo "
alias apt="apt-fast"
alias dolroot="pkexec env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY KDE_SESSION_VERSION=5 KDE_FULL_SESSION=true dolphin"
alias bettercap="docker run --rm -it --privileged --net=host bettercap/bettercap"
alias photorec="sudo /home/kn/.local/share/testdisk/photorec_static"
alias android-emulator="/home/kn/Android/Sdk/emulator/emulator -avd Resizable_API_33 </dev/null &> /dev/null & disown"
alias sudo="sudo "
alias apt="apt-fast"
alias cat='pygmentize -g'

nvrun() {
    __NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia "$@"
}
nvenv(){
        echo "__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia"
        echo "__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia" | xclip -selection clipboard
}
ca-create(){
        openssl genrsa -out ca.key
        openssl req -new -key ca.key -out ca.csr
        openssl x509 -req -days 365 -in ca.csr -signkey ca.key -out ca.crt
}
cert-create(){
        openssl genrsa -out cert.key
        openssl req -new -key cert.key -out cert.csr
        openssl x509 -req -in cert.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out cert.crt -days 365
        openssl verify -CAfile ca.crt cert.crt
}
strlength() {
    local input="$1"
    local length=${#input}
    echo "$length"
}

ranb64() {
    local length=${1:-32}
    if [[ $length -le 0 ]]; then
        echo "Error: Length should be a positive integer."
        return 1
    fi
    random_bytes=$(head -c "$length" /dev/urandom | base64 | tr -d '\n')
    echo "$random_bytes"
}
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
ccssh() {
    if [ -z "$1" ]; then
        config_file="$PWD/config"
    else
        config_file="$1"
    fi
    if [ ! -f "$config_file" ]; then
        echo "Config file not found: $config_file"
        return 1
    fi
    hosts=$(awk '/^Host/ {print $2}' "$config_file")
    server=""
    for host in $hosts; do
        server+="${server} $(echo -n "$host" | tr '\n' ' ') "
    done
    eval "cssh $server </dev/null &> /dev/null & disown"
}
sshsmreboot() {
  if [ -z "$1" ]; then
    echo "Usage: sshsmreboot <delay_seconds> <ssh_server1> [<ssh_server2> ...]"
    return 1
  fi
  delay="$1"
  shift
  for server in "$@"; do
    echo "Rebooting SSH server $server at $(date +'%Y-%m-%d %H:%M:%S')"
    ssh "$server" sudo reboot
    sleep "$delay"
  done
}
sshfmreboot() {
  if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Usage: sshfmreboot <delay_seconds> <config_file>"
    return 1
  fi

  delay="$1"
  config_file="$2"

  if [ ! -f "$config_file" ]; then
    echo "Config file not found: $config_file"
    return 1
  fi

  hosts=$(awk '/^Host/ {print $2}' "$config_file")

  for host in $hosts; do
    echo "Rebooting SSH server $host at $(date +'%Y-%m-%d %H:%M:%S')"
    ssh -F ${config_file} "$host" sudo reboot
    sleep "$delay"
  done
}

to-mov(){
        for (( i=1; i <= "$#"; i++ )); do
                #echo "${!i}"
                ffmpeg -i "${!i}" -vcodec mjpeg -q:v 2 -acodec pcm_s16be -q:a 0 -f mov "${!i}".mov
        done
}

mbscan() {
    if [ $# -eq 2 ]; then
        adb -s $2 shell input text "$1"
        adb -s $2 shell input keyevent 66
    elif [ $# -eq 1 ]; then
        for device in $(adb devices | grep -v "List of devices" | cut -f1);
        do
            adb -s $device shell input text "$1"
            adb -s $device shell input keyevent 66
        done
    else
        echo "Invalid number of arguments. Usage: mbscan <value> [device_id]"
    fi
}
