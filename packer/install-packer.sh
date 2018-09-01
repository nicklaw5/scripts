#!/usr/bin/env bash

#############################################################
## USAGE EXAMPLE (default):
## $ VERSION=1.2.5 PROC=amd64 DISTRO=linux ./install-packer.sh
#############################################################

set -e

DISTRO=${DISTRO:-linux} # Options: darwin, freebsd, linux, openbsd, windows
PROC=${PROC:-amd64} # Options: 386, amd64, arm
VERSION=${VERSION:-1.2.5} # See https://github.com/hashicorp/packer/releases

# Download release if not already exists
if [[ ! -f /tmp/packer_$VERSION\_$DISTRO\_$PROC.zip ]] || [[ ! -f /tmp/packer_$VERSION\_SHA256SUMS ]] ; then
    echo "Downloading release zip ..."
    wget -q --output-document=/tmp/packer_$VERSION\_$DISTRO\_$PROC.zip \
        https://releases.hashicorp.com/packer/$VERSION/packer_$VERSION\_$DISTRO\_$PROC.zip

    echo "Downloading checksum file ..."
    wget -q --output-document=/tmp/packer_$VERSION\_SHA256SUMS \
        https://releases.hashicorp.com/packer/$VERSION/packer_$VERSION\_SHA256SUMS

    printf "Verifying checksum ... "
    CHECKSUM=$(sha256sum /tmp/packer_$VERSION\_$DISTRO\_$PROC.zip)
    CHECKSUM_GREP=$(grep -F $CHECKSUM /tmp/packer_$VERSION\_SHA256SUMS || echo "")
    if [[ $CHECKSUM_GREP == "" ]] ; then
        printf 'Error: Invalid checksum\n'
        exit 1
    fi
    printf "OK\n"
fi

# Remove old versions of Packer
echo "Removing previous release ..."
sudo rm -rf /tmp/packer
sudo rm -rf /usr/local/packer

# Unzip release and install executable
echo "Unpacking release zip ..."
unzip -q -d /tmp/packer /tmp/packer_$VERSION\_$DISTRO\_$PROC.zip
sudo mv /tmp/packer /usr/local

# Add Packer executable to $PATH if not already set
echo "Updating \$PATH to include packer executable ..."
grep -q -F '/usr/local/packer' /etc/environment \
    || echo $(echo PATH=\"$PATH:/usr/local/packer\") | sudo tee /etc/environment > /dev/null
source /etc/environment

# Display installed Packer version
echo "Installation complete: $(packer version)"
