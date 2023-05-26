#!/bin/bash

<<'MULTILINE-COMMENT'
    Requirments: none
    Description: Script for install and configure Terraform Tools for labs.
    Author: Marcos Silvestrini
    Date: 17/05/2023
MULTILINE-COMMENT

# Set language/locale and encoding
export LANG=C

# Set workdir
WORKDIR="/home/vagrant"
cd $WORKDIR || exit

# Variables
DISTRO=$(cat /etc/*release | grep -ws NAME=)

# Check if distribution is Debian
if [[ "$DISTRO" == *"Debian"* ]]; then    
    echo "Distribution is Debian...Congratulations!!!"
else    
    echo "This script is not available for RPM distributions!!!";exit 1;
fi

# Install Terraform

## Install the HashiCorp GPG key
curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add -

## Add hashicorp repository
apt-add-repository "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release -cs) main"


## Update repo index
apt-get update -y

## Install terraform package
apt-get install terraform -y

## Check installation
terraform -v
