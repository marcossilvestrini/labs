#!/bin/bash
<<'SCRIPT-FUNCTION'
    Description: Script for check nginx Stack
    Author: Marcos Silvestrini
    Date: 23/02/2023
SCRIPT-FUNCTION

#Set localizations for prevent bugs in operations
LANG=C

# Set workdir
cd /home/vagrant || exit

#Variables
IP_NGINX_PROXY="192.168.0.131"
IP_NODE01="192.168.0.140"
IP_NODE02="192.168.0.141"

# File for outputs testing
FILE_TEST=test/nginx/check-nginx-stack.txt
LINE="------------------------------------------------------"

echo $LINE >$FILE_TEST
echo "Check Nginx Stack for This Lab" >>$FILE_TEST
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "Date: $DATE" >>$FILE_TEST
echo -e "$LINE\n" >>$FILE_TEST

# Check nginx Proxy
echo $LINE >>$FILE_TEST
echo "Check Nginx PROXY..." >>$FILE_TEST
echo -e "$LINE\n" >>$FILE_TEST

## Check status
echo -e "Check Status of nginx Proxy...\n" >>$FILE_TEST
sshpass -p 'vagrant' ssh -o StrictHostKeyChecking=no vagrant@$IP_NGINX_PROXY -l vagrant \
    systemctl status nginx | grep "Active" >>$FILE_TEST
echo $LINE >>$FILE_TEST

## Check version of nginx
echo -e "Check version of nginx Proxy...\n" >>$FILE_TEST
sshpass -p 'vagrant' ssh -o StrictHostKeyChecking=no vagrant@$IP_NGINX_PROXY -l vagrant \
    sudo nginx -v >>$FILE_TEST 2>&1
echo $LINE >>$FILE_TEST

## Check https status code
echo -e "Check https status code of nginx Proxy...\n" >>$FILE_TEST
echo -e "Site: https://silvestrini.skynet.com.br...\n" >>$FILE_TEST
curl -LI -k https://silvestrini.skynet.com.br -o /dev/null -w '%{http_code}\n' -s >>$FILE_TEST
echo $LINE >>$FILE_TEST

## Check php status
echo -e "Check php status of nginx Proxy...\n" >>$FILE_TEST
echo -e "Aplication PHP: https://silvestrini.skynet.com.br/php/info.php...\n" >>$FILE_TEST
curl -LI -k https://silvestrini.skynet.com.br/php/info.php -o /dev/null -w '%{http_code}\n' -s >>$FILE_TEST
echo $LINE >>$FILE_TEST

## Check perl status
echo -e "Check perl status of nginx Proxy..." >>$FILE_TEST
echo -e "Aplication PERL: https://silvestrini.skynet.com.br/perl/app.pl...\n" >>$FILE_TEST
curl -LI -k https://silvestrini.skynet.com.br/perl/app.pl -o /dev/null -w '%{http_code}\n' -s >>$FILE_TEST
echo $LINE >>$FILE_TEST

# Check nginx  NODE01
echo $LINE >>$FILE_TEST
echo "Check nginx NODE01..." >>$FILE_TEST
echo -e "$LINE\n" >>$FILE_TEST

## Check status
echo -e "Check status of nginx NODE01...\n" >>$FILE_TEST
sshpass -p 'vagrant' ssh -o StrictHostKeyChecking=no vagrant@$IP_NODE01 -l vagrant \
    sudo systemctl status nginx | grep "Active" >>$FILE_TEST
echo $LINE >>$FILE_TEST

## Check version of nginx
echo -e "Check version of nginx NODE01...\n" >>$FILE_TEST
sshpass -p 'vagrant' ssh -o StrictHostKeyChecking=no vagrant@$IP_NODE01 -l vagrant \
    sudo nginx -v >>$FILE_TEST 2>&1
echo $LINE >>$FILE_TEST

## Check http status code
echo -e "Check http status code of nginx NODE01..." >>$FILE_TEST
echo -e "Site: https://node01-silvestrini.skynet.com.br...\n" >>$FILE_TEST
curl -LI -k https://node01-silvestrini.skynet.com.br -o /dev/null -w '%{http_code}\n' -s >>$FILE_TEST
echo $LINE >>$FILE_TEST

## Check php status
echo -e "Check php status of nginx NODE01..." >>$FILE_TEST
echo -e "Aplication PHP: https://node01-silvestrini.skynet.com.br/php/info.php...\n" >>$FILE_TEST
curl -LI -k https://node01-silvestrini.skynet.com.br/php/info.php -o /dev/null -w '%{http_code}\n' -s >>$FILE_TEST
echo $LINE >>$FILE_TEST

## Check perl status
echo -e "Check perl status of nginx NODE01..." >>$FILE_TEST
echo -e "Aplication PERL: https://node01-silvestrini.skynet.com.br/perl/app.pl...\n" >>$FILE_TEST
curl -LI -k https://node01-silvestrini.skynet.com.br/perl/app.pl -o /dev/null -w '%{http_code}\n' -s >>$FILE_TEST
echo $LINE >>$FILE_TEST


# Check nginx  NODE02
echo $LINE >>$FILE_TEST
echo "Check nginx NODE02..." >>$FILE_TEST
echo -e "$LINE\n" >>$FILE_TEST

## Check status
echo -e "Check status of nginx NODE02...\n" >>$FILE_TEST
sshpass -p 'vagrant' ssh -o StrictHostKeyChecking=no vagrant@$IP_NODE02 -l vagrant \
    sudo systemctl status nginx | grep "Active" >>$FILE_TEST
echo $LINE >>$FILE_TEST

## Check version of nginx
echo -e "Check version of nginx NODE02...\n" >>$FILE_TEST
sshpass -p 'vagrant' ssh -o StrictHostKeyChecking=no vagrant@$IP_NODE02 -l vagrant \
    sudo nginx -v >>$FILE_TEST 2>&1
echo $LINE >>$FILE_TEST

## Check http status code
echo -e "Check http status code of nginx NODE02..." >>$FILE_TEST
echo -e "Site: https://node02-silvestrini.skynet.com.br...\n" >>$FILE_TEST
curl -LI -k https://node02-silvestrini.skynet.com.br -o /dev/null -w '%{http_code}\n' -s >>$FILE_TEST
echo $LINE >>$FILE_TEST

## Check php status
echo -e "Check php status of nginx NODE02..." >>$FILE_TEST
echo -e "Aplication PHP: https://node02-silvestrini.skynet.com.br/php/info.php...\n" >>$FILE_TEST
curl -LI -k https://node02-silvestrini.skynet.com.br/php/info.php -o /dev/null -w '%{http_code}\n' -s >>$FILE_TEST
echo $LINE >>$FILE_TEST

## Check perl status
echo -e "Check perl status of nginx NODE02..." >>$FILE_TEST
echo -e "Aplication PERL: https://node02-silvestrini.skynet.com.br/perl/app.pl...\n" >>$FILE_TEST
curl -LI -k https://node02-silvestrini.skynet.com.br/perl/app.pl -o /dev/null -w '%{http_code}\n' -s >>$FILE_TEST
echo $LINE >>$FILE_TEST