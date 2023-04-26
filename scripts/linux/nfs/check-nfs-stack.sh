#!/bin/bash
<<'SCRIPT-FUNCTION'
    Description: Script for check nfs Stack
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
FILE_TEST=test/nfs/check-nfs-stack.txt
LINE="------------------------------------------------------"

echo $LINE >$FILE_TEST
echo "Check nfs Stack for This Lab" >>$FILE_TEST
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "Date: $DATE" >>$FILE_TEST
echo -e "$LINE\n" >>$FILE_TEST

# Check nfs status
echo $LINE >>$FILE_TEST
echo -e "Check Status of nfs in server $IP_VM_OL9_01...\n" >>$FILE_TEST
sshpass -p 'vagrant' ssh -o StrictHostKeyChecking=no vagrant@$IP_VM_OL9_01 -l vagrant \
    systemctl status nfs-server | grep "Active" >>$FILE_TEST    
echo $LINE >>$FILE_TEST

echo -e "Check Status of nfs in server $IP_VM_DEBIAN_01...\n" >>$FILE_TEST
sshpass -p 'vagrant' ssh -o StrictHostKeyChecking=no vagrant@$IP_VM_DEBIAN_01 -l vagrant \
    systemctl status nfs-server | grep "Active" >>$FILE_TEST    
echo $LINE >>$FILE_TEST

# Check version of nfs
echo -e "Check version of nfs in server $IP_VM_OL9_01...\n" >>$FILE_TEST
sshpass -p 'vagrant' ssh -o StrictHostKeyChecking=no vagrant@$IP_VM_OL9_01 -l vagrant \
    sudo nfsstat –c | grep -ws "Server rpc stats" -A 10 >>$FILE_TEST     
echo $LINE >>$FILE_TEST

echo -e "Check version of nfs in server $IP_VM_DEBIAN_01...\n" >>$FILE_TEST
sshpass -p 'vagrant' ssh -o StrictHostKeyChecking=no vagrant@$IP_VM_DEBIAN_01 -l vagrant \
    sudo /usr/sbin/nfsstat –c | grep -ws "Server rpc stats" -A 10 >>$FILE_TEST     
echo $LINE >>$FILE_TEST

# Check nfs connections
echo -e "Check nfs connections...\n" >>$FILE_TEST
ss -a|grep :nfs >>$FILE_TEST
echo $LINE >>$FILE_TEST

# Check mount points
echo -e "Check nfs mount points...\n" >>$FILE_TEST
cat /proc/mounts | grep nfs | cut -d' ' -f1,2,3 >>$FILE_TEST
echo $LINE >>$FILE_TEST
