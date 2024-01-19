sshsmreboot() {
  # Check if the delay parameter is provided
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


alias dolroot="pkexec env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY KDE_SESSION_VERSION=5 KDE_FULL_SESSION=true dolphin"
alias android-emulator="/home/kn/Android/Sdk/emulator/emulator -avd Resizable_API_33 </dev/null &> /dev/null & disown"


# create a cerificate
openssl req -new -newkey rsa:2048 -days 365 -nodes -x509 -keyout domain.key -out domain.crt
