#!/bin/bash


if [ -z "$1" ]; then
    echo "Error: URL is required."
    echo "Usage: $0 <url>"
    echo "Example: $0 http://ca-host/ca.crt"
    exit 1
fi

URL="$1"
TEMP_CERT="/tmp/ca-cert.crt"

# Download the certificate
echo "Downloading certificate from $URL..."
curl -o "$TEMP_CERT" "$URL"
if [ $? -ne 0 ]; then
    echo "Error: Failed to download certificate."
    exit 1
fi

# Install the certificate
echo "Installing certificate..."
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    sudo cp "$TEMP_CERT" /usr/local/share/ca-certificates/
    sudo update-ca-certificates
elif [[ "$OSTYPE" == "darwin"* ]]; then
    sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain "$TEMP_CERT"
else
    echo "Error: Unsupported OS type: $OSTYPE"
    exit 1
fi

# Clean up temporary certificate file
rm "$TEMP_CERT"

echo "Certificate installed successfully."
