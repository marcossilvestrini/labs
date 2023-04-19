#!/bin/bash
<<'SCRIPT-FUNCTION'
    Description: Script for check stack of OpenLDAP server
    Author: Marcos Silvestrini
    Date: 17/04/2023
SCRIPT-FUNCTION

#Set localizations for prevent bugs in operations
LANG=C

# Set workdir
cd /home/vagrant || exit

# Variables
IP_OPENLDAP="192.168.0.140"

# File for outputs testing
FILE_TEST=test/openldap/check-openldap-stack.txt
LINE="------------------------------------------------------"

echo $LINE >$FILE_TEST
echo "Check OpenLDAP Stack for This Lab" >>$FILE_TEST
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "Date: $DATE" >>$FILE_TEST
echo -e "$LINE\n" >>$FILE_TEST

## Check version of openldap
echo -e "Check version of openldap server..." >>$FILE_TEST
sshpass -p 'vagrant' ssh -o StrictHostKeyChecking=no vagrant@$IP_OPENLDAP -l vagrant sudo slapd -V  >>$FILE_TEST 2>&1
echo $LINE >>$FILE_TEST

## Check status of openldap
echo -e "Check status of service openldap server...\n" >>$FILE_TEST
sshpass -p 'vagrant' ssh -o StrictHostKeyChecking=no vagrant@$IP_OPENLDAP -l vagrant sudo systemctl status slapd | grep -ws "slapd.service" -A 2 >>$FILE_TEST 2>&1
echo $LINE >>$FILE_TEST

## Check OpenLDAP custom database
echo -e "Find Informations in OpenLDAP Custom Database [ "dc=skynet,dc=com,dc=br" cn=Marcos]...\n" >>$FILE_TEST
ldapsearch -x -h debian-server01 -b "dc=skynet,dc=com,dc=br" cn=Marcos >>$FILE_TEST
# sshpass -p 'vagrant' ssh -o StrictHostKeyChecking=no vagrant@$IP_OPENLDAP -l vagrant sudo cat /etc/openldap/openldapd.conf | grep -ws "Set openldap Range" -A 5 >>$FILE_TEST
# sshpass -p 'vagrant' ssh -o StrictHostKeyChecking=no vagrant@$IP_OPENLDAP -l vagrant sudo cat /etc/openldap/openldapd.conf | grep -ws "Set openldap clients" -A 5 >>$FILE_TEST
echo $LINE >>$FILE_TEST
