#!/bin/bash

# Check if the required arguments (IPs, token, certificate files) are provided
if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ] || [ -z "$4" ] || [ -z "$5" ]; then
  echo "Usage: $0 <comma-separated list of IPs> <cluster_token> <cert_file> <key_file> <ca_file>"
  exit 1
fi

# Input parameters
ips_input=$1
cluster_token=$2
cert_file=$3
key_file=$4
ca_file=$5

# Split the comma-separated IPs into an array
IFS=',' read -r -a ips <<< "$ips_input"

# Get the total number of IPs
num_ips=${#ips[@]}

# Iterate through the IPs and generate the docker run commands
for ((i = 0; i < num_ips; i++)); do
  # Get the current IP
  ip="${ips[$i]}"
  
  # Generate the etcd container name (etcd0, etcd1, etcd2, etc.)
  container_name="etcd-$i"
  
  # Generate the list of other nodes in the cluster
  initial_cluster=""
  for ((j = 0; j < num_ips; j++)); do
    if [ "$j" -eq "$i" ]; then
      continue
    fi
    if [ -z "$initial_cluster" ]; then
      initial_cluster="etcd$j=http://${ips[$j]}:2380"
    else
      initial_cluster="$initial_cluster,etcd$j=http://${ips[$j]}:2380"
    fi
  done
  
  # Generate the docker run command with SSL certificates and other parameters
  echo "docker run -d \\
  --name $container_name \\
  --net host \\
  -v /etc/etcd/ssl:/etc/etcd/ssl:ro \\
  -e ETCD_NAME=$container_name \\
  -e ETCD_LISTEN_PEER_URLS=https://$ip:2380 \\
  -e ETCD_LISTEN_CLIENT_URLS=https://$ip:2379 \\
  -e ETCD_INITIAL_ADVERTISE_PEER_URLS=https://$ip:2380 \\
  -e ETCD_ADVERTISE_CLIENT_URLS=https://$ip:2379 \\
  -e ETCD_INITIAL_CLUSTER=$initial_cluster \\
  -e ETCD_INITIAL_CLUSTER_TOKEN=$cluster_token \\
  -e ETCD_INITIAL_CLUSTER_STATE=new \\
  -e ETCD_DATA_DIR=/etcd-data \\
  -e ETCD_CERT_FILE=$cert_file \\
  -e ETCD_KEY_FILE=$key_file \\
  -e ETCD_TRUSTED_CA_FILE=$ca_file \\
  quay.io/coreos/etcd:v3.5.0"
  
  echo # Add an empty line between commands for better readability
done
