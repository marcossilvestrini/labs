#!/bin/bash

<<'MULTILINE-COMMENT'
    Requirments: none
    Description: Script for configure server http client
    Author: Marcos Silvestrini
    Date: 24/04/2023
MULTILINE-COMMENT

export LANG=C

cd /home/vagrant || exit

# Install packages

# ## Install chrome
wget -qO - https://dl.google.com/linux/linux_signing_key.pub |
    gpg --dearmor -o /usr/share/keyrings/googlechrome-linux-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/googlechrome-linux-keyring.gpg] http://dl.google.com/linux/chrome/deb/ stable main" |
    tee /etc/apt/sources.list.d/google-chrome.list
apt update -y
apt install -y google-chrome-stable

## Install firefox
apt install -y firefox-esr

## Certificate utils
apt install -y libnss3-tools

# Copy certificates
cp configs/apache/security/skynet.com.br-ca-cert.pem configs/apache/security/skynet.com.br-client-cert.p12 .
dos2unix skynet.com.br-ca-cert.pem
