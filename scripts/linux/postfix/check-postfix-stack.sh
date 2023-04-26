#!/bin/bash
<<'SCRIPT-FUNCTION'
    Description: Script for check Postfix Stack
    Author: Marcos Silvestrini
    Date: 24/04/2023
SCRIPT-FUNCTION

#Set localizations for prevent bugs in operations
LANG=C

# Set workdir
cd /home/vagrant || exit

#Variables
IP_POSTFIX="192.168.0.130"


# File for outputs testing
FILE_TEST=test/postfix/check-postfix-stack.txt
LINE="------------------------------------------------------"

echo $LINE >$FILE_TEST
echo "Check postfix Stack for This Lab" >>$FILE_TEST
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "Date: $DATE" >>$FILE_TEST
echo -e "$LINE\n" >>$FILE_TEST

# Check postfix status
echo $LINE >>$FILE_TEST
echo -e "Check Status of Postfix...\n" >>$FILE_TEST
sshpass -p 'vagrant' ssh -o StrictHostKeyChecking=no vagrant@$IP_POSTFIX -l vagrant \
    systemctl status postfix | grep "Active" >>$FILE_TEST
echo $LINE >>$FILE_TEST

# Check version of postfix
echo -e "Check version of postfix...\n" >>$FILE_TEST
sshpass -p 'vagrant' ssh -o StrictHostKeyChecking=no vagrant@$IP_POSTFIX -l vagrant \
    sudo postconf -d mail_version >>$FILE_TEST 2>&1
echo $LINE >>$FILE_TEST

# Check dovecot status
echo -e "Check Status of Dovecot...\n" >>$FILE_TEST
sshpass -p 'vagrant' ssh -o StrictHostKeyChecking=no vagrant@$IP_POSTFIX -l vagrant \
    systemctl status dovecot | grep "Active" >>$FILE_TEST
echo $LINE >>$FILE_TEST

# Check version of dovecot
echo -e "Check version of Dovecot...\n" >>$FILE_TEST
sshpass -p 'vagrant' ssh -o StrictHostKeyChecking=no vagrant@$IP_POSTFIX -l vagrant \
    sudo dovecot --version >>$FILE_TEST 2>&1
echo $LINE >>$FILE_TEST

# Send Test Mail Message for postfix
echo -e "Send Test Mail Message for Postfix server..." >>$FILE_TEST
sshpass -p 'vagrant' ssh -t -o StrictHostKeyChecking=no vagrant@$IP_POSTFIX -l vagrant \
    'cat configs/postfix/mail.txt |sudo sendmail -f root@skynet.com.br -t vagrant@skynet.com.br'
if [ $? -eq 0 ]; then
    echo "Send test mail succeeded" >>$FILE_TEST
else
    echo "Send test mail failed" >>$FILE_TEST
fi
echo $LINE >>$FILE_TEST

# Read the test mail in postfix
echo -e "Read Test Mail Message for Postfix server...\n" >>$FILE_TEST
sshpass -p 'vagrant' ssh -t -o StrictHostKeyChecking=no vagrant@$IP_POSTFIX -l vagrant \
    'echo "type 1" | mail' | grep -ws To: -A 6 >>$FILE_TEST
echo $LINE >>$FILE_TEST