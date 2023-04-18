#!/bin/bash

<<'SCRIPT-FUNCTIONS'
    Requirements: none
    Description: Script for Install and Configure OpenLDAP Server
    Author: Marcos Silvestrini
    Date: 17/04/2023
SCRIPT-FUNCTIONS

export LANG=C

# Variables
DISTRO=$(cat /etc/*release | grep -ws NAME=)

# Install OpenLDAP Server
if [[ $DISTRO == *"Debian"* ]]; then  
  echo 'slapd/root_password password vagrant' | debconf-set-selections \
  && echo 'slapd/root_password_again password vagrant' | debconf-set-selections \
  && echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
  apt-get install -y slapd ldap-utils  
else
  echo "DISTRO NOTE SUPORTED BY THIS SCRIPT!!!!"
  exit 1
fi

# Configure OpenLDAP Server - (Method use actual by OpenLDAP - slapd.d)
#https://www.ibm.com/docs/en/rpa/21.0?topic=ldap-installing-configuring-openldap

## Check configuration
slaptest

## Modify OpenLDAP database for my custom dc
ldapmodify -Y EXTERNAL -H ldapi:/// -f configs/openldap/db.ldif

## Import defaults schemas
ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/ldap/schema/cosine.ldif
ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/ldap/schema/nis.ldif
ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/ldap/schema/inetorgperson.ldif
ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/ldap/schema/openldap.ldif
ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/ldap/schema/dyngroup.ldif

## Create LDAP databases(.ldif)
systemctl stop slapd
rm /var/lib/ldap/*
systemctl start slapd
sudo ldapadd -w "vagrant" -D "cn=admin,dc=skynet,dc=com,dc=br" -f configs/openldap/skynet.ldif
