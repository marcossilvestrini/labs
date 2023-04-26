#!/bin/bash
<<'SCRIPT-FUNCTION'
    Description: Script for check Samba Stack
    Author: Marcos Silvestrini
    Date: 24/04/2023
SCRIPT-FUNCTION

#Set localizations for prevent bugs in operations
LANG=C

# Set workdir
cd /home/vagrant || exit

#Variables
IP_VM_OL9_01="192.168.0.130"
IP_VM_DEBIAN_01="192.168.0.140"


# File for outputs testing
FILE_TEST=test/samba/check-samba-stack.txt
LINE="------------------------------------------------------"

echo $LINE >$FILE_TEST
echo "Check Samba Stack for This Lab" >>$FILE_TEST
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "Date: $DATE" >>$FILE_TEST
echo -e "$LINE\n" >>$FILE_TEST

# Check samba status
echo $LINE >>$FILE_TEST
echo -e "Check Status of samba in server $IP_VM_OL9_01...\n" >>$FILE_TEST
sshpass -p 'vagrant' ssh -o StrictHostKeyChecking=no vagrant@$IP_VM_OL9_01 -l vagrant \
    systemctl status smb | grep "Active" >>$FILE_TEST
echo $LINE >>$FILE_TEST

echo $LINE >>$FILE_TEST
echo -e "Check Status of samba in server $IP_VM_DEBIAN_01...\n" >>$FILE_TEST
sshpass -p 'vagrant' ssh -o StrictHostKeyChecking=no vagrant@$IP_VM_DEBIAN_01 -l vagrant \
    systemctl status smbd | grep "Active" >>$FILE_TEST
echo $LINE >>$FILE_TEST

# Check version of samba
echo -e "Check version of samba in server $IP_VM_OL9_01...\n" >>$FILE_TEST
sshpass -p 'vagrant' ssh -o StrictHostKeyChecking=no vagrant@$IP_VM_OL9_01 -l vagrant \
    smbstatus -V >>$FILE_TEST 
echo $LINE >>$FILE_TEST

echo -e "Check version of samba in server $IP_VM_DEBIAN_01...\n" >>$FILE_TEST
sshpass -p 'vagrant' ssh -o StrictHostKeyChecking=no vagrant@$IP_VM_DEBIAN_01 -l vagrant \
    sudo smbstatus -V >>$FILE_TEST
echo $LINE >>$FILE_TEST

# Check mount points
echo -e "Check samba cifs mount points...\n" >>$FILE_TEST
mount -t cifs | cut -d' ' -f1,2,3,4,5 >>$FILE_TEST
echo $LINE >>$FILE_TEST
