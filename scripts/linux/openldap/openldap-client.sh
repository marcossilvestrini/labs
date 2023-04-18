#!/bin/bash

<<'SCRIPT-FUNCTIONS'
    Requirements: none
    Description: Script for Install and Configure OpenLDAP Client and Utilities
    Author: Marcos Silvestrini
    Date: 17/04/2023
SCRIPT-FUNCTIONS

export LANG=C

# Variables
DISTRO=$(cat /etc/*release | grep -ws NAME=)

# Install OpenLDAP Client and Utilities
if [[ $DISTRO == *"Debian"* ]]; then
    apt-get install -y jxplorer
    apt-get install -y ldap-utils
    
else
    dnf install -y jxplorer
fi

# Apache Directory
rm -rf /opt/*ApacheDirectoryStudio*
wget -O /opt/ApacheDirectoryStudio-2.0.0.tar.gz https://dlcdn.apache.org/directory/studio/2.0.0.v20210717-M17/ApacheDirectoryStudio-2.0.0.v20210717-M17-linux.gtk.x86_64.tar.gz
tar xvfx /opt/ApacheDirectoryStudio-2.0.0.tar.gz -C  /opt