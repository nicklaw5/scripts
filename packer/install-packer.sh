#!/usr/bin/env bash

#############################################################
## USAGE EXAMPLE (default):
## $ VERSION=1.2.5 PROC=amd64 DISTRO=linux ./install-packer.sh
#############################################################

DISTRO=${DISTRO:-linux} # Options: darwin, freebsd, linux, openbsd, windows
PROC=${PROC:-amd64} # Options: 386, amd64, arm
VERSION=${VERSION:-1.2.5} # See https://github.com/hashicorp/packer/releases

# Download release if not already exists
if [ ! -f /tmp/packer_$VERSION\_$DISTRO\_$PROC.zip ]; then
    wget --output-document=/tmp/packer_$VERSION\_$DISTRO\_$PROC.zip \
        https://releases.hashicorp.com/packer/$VERSION/packer_$VERSION\_$DISTRO\_$PROC.zip
fi

# Remove old versions of Packer
sudo rm -rf /tmp/packer
sudo rm -rf /usr/local/packer

# Unzip release and install executable
unzip -q -d /tmp/packer /tmp/packer_$VERSION\_$DISTRO\_$PROC.zip
sudo mv /tmp/packer /usr/local

# Add Packer executable to $PATH if not already set
grep -q -F '/usr/local/packer' /etc/environment \
    || echo $(echo PATH=\"$PATH:/usr/local/packer\") | sudo tee /etc/environment > /dev/null

# Reload $PATH
source /etc/environment

# Display installed Packer version
packer version
