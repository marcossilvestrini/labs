#!/bin/bash

<<'MULTILINE-COMMENT'
    Requirments: none
    Description: Script for configure apache nodes
    Author: Marcos Silvestrini
    Date: 18/04/2023
MULTILINE-COMMENT

export LANG=C

#Variables
PRIVATE_IP=$(ip add show | grep 192.168.0 | cut -c 10-22)
MACHINE_NAME=$(hostname -f)

cd /home/vagrant || exit

# Install packages
apt install -y w3m
apt install -y apache2

# Copy certificates from server ol9-server01 to local machine
sshpass -p "vagrant" sudo  scp -o StrictHostKeyChecking=no vagrant@ol9-server02:/etc/ssl/certs/skynet* /etc/ssl/certs

# Tunning apache

## Fix error (2)No such file or directory: AH02297: Cannot access directory '/etc/apache2/logs/' for log file
# mkdir -p /etc/apache2/logs


## Enable SSL\TLS
#-rw-r--r-- 1 root root 6338 Mar  8 00:04 /etc/apache2/sites-available/default-ssl.conf
cp configs/apache/apache-node/default-ssl.conf /etc/apache2/sites-available/
dos2unix /etc/apache2/sites-available/default-ssl.conf
chmod 644 /etc/apache2/sites-available/default-ssl.conf
a2ensite default-ssl
a2enmod ssl


# Configure Apache Default Site
cp configs/apache/apache-node/000-default.conf /etc/apache2/sites-available
dos2unix /etc/apache2/sites-available/000-default.conf
chmod 644 /etc/apache2/sites-available/000-default.conf
a2enmod rewrite
#a2ensite 000-default

## Configure MPM mod
# lrwxrwxrwx 1 root root 32 Feb 23 14:48 mpm_event.conf -> ../mods-available/mpm_event.conf
cp -f configs/apache/apache-node/mpm_event.conf /etc/apache2/mods-available/
dos2unix /etc/apache2/mods-available/mpm_event.conf


# Create user autentication db for sites
mkdir -p /etc/httpd/htpasswd
echo "vagrant" | htpasswd -c -i /etc/httpd/htpasswd/.htpasswd vagrant
echo "silvestrini" | htpasswd -i /etc/httpd/htpasswd/.htpasswd silvestrini
echo "skynet" | htpasswd -i /etc/httpd/htpasswd/.htpasswd skynet
cp  configs/apache/security/.htgroup /etc/httpd/htpasswd
dos2unix /etc/httpd/htpasswd/.htgroup

# Create www.skynet.com.br/topsecret
mkdir -p /var/www/html/topsecret
touch /var/www/html/topsecret/"$(hostname)"
touch /var/www/html/topsecret/topsecret_file{1..3}
cp configs/apache/security/.htaccess /var/www/html/topsecret
dos2unix /var/www/html/topsecret/.htaccess

# Create www.skynet.com.br/admin
mkdir -p /var/www/html/admin
touch /var/www/html/admin/"$(hostname)"
touch /var/www/html/admin/admin_file{1..3}
cp configs/apache/security/.htaccess_admin /var/www/html/admin/.htaccess
dos2unix /var/www/html/admin/.htaccess

# Create www.skynet.com.br/logs
cp configs/apache/security/.htaccess /var/log/httpd
dos2unix /var/log/httpd/.htaccess
chmod 755 -R /var/log/apache2

# Create Main Site - www.skynet.com.br and set: Virtualhost, alias and redirects
cp -f configs/apache/html/index.html /var/www/html/
sed -i "s/var_ip/$PRIVATE_IP/g" "/var/www/html/index.html"
sed -i "s/var_hostname/$MACHINE_NAME/g" "/var/www/html/index.html"
dos2unix /var/www/html/index.html

# Create silvestrini.skynet.com.br and set: Virtualhost, alias and redirects
mkdir -p {/var/www/html/silvestrini,/var/www/html/silvestrini/docs}
touch /var/www/html/silvestrini/docs/"$(hostname)"
touch /var/www/html/silvestrini/docs/doc{1..6}
cp configs/apache/apache-node/silvestrini.conf /etc/apache2/sites-available
dos2unix /etc/apache2/sites-available/silvestrini.conf
chmod 644 /etc/apache2/sites-available/silvestrini.conf
cp configs/apache/html/index-silvestrini.html /var/www/html/silvestrini/index.html
sed -i "s/var_ip/$PRIVATE_IP/g" "/var/www/html/silvestrini/index.html"
sed -i "s/var_hostname/$MACHINE_NAME/g" "/var/www/html/silvestrini/index.html"
a2ensite silvestrini

## Site music.skynet.com.br
mkdir -p /var/www/html/music
cp configs/apache/apache-node/music.conf /etc/apache2/sites-available
dos2unix /etc/apache2/sites-available/music.conf
chmod 644 /etc/apache2/sites-available/music.conf
cp configs/apache/html/index-music.html /var/www/html/music/index.html
sed -i "s/var_ip/$PRIVATE_IP/g" "/var/www/html/music/index.html"
sed -i "s/var_hostname/$MACHINE_NAME/g" "/var/www/html/music/index.html"
a2ensite music

## Site store.skynet.com.br
mkdir -p /var/www/html/store
cp configs/apache/apache-node/store.conf /etc/apache2/sites-available
dos2unix /etc/apache2/sites-available/store.conf
chmod 644 /etc/apache2/sites-available/store.conf
cp configs/apache/html/index-store.html /var/www/html/store/index.html
sed -i "s/var_ip/$PRIVATE_IP/g" "/var/www/html/store/index.html"
sed -i "s/var_hostname/$MACHINE_NAME/g" "/var/www/html/store/index.html"
a2ensite store

## Site - finance.skynet.com.br
mkdir -p /var/www/html/finance
cp configs/apache/apache-node/finance.conf /etc/apache2/sites-available
dos2unix /etc/apache2/sites-available/finance.conf
chmod 644 /etc/apache2/sites-available/finance.conf
cp configs/apache/html/index-finance.html /var/www/html/finance/index.html
sed -i "s/var_ip/$PRIVATE_IP/g" "/var/www/html/finance/index.html"
sed -i "s/var_hostname/$MACHINE_NAME/g" "/var/www/html/finance/index.html"
a2ensite finance


# Install php app
apt install -y php
mkdir /var/www/html/silvestrini/php
cp -f configs/apache/backend/info.php /var/www/html/silvestrini/php

# Install perl app
apt install -y libapache2-mod-perl2
a2enmod cgid -q -f
a2enmod authz_groupfile -q -f
mkdir /var/www/html/silvestrini/perl
cp configs/apache/backend/app.pl /var/www/html/silvestrini/perl/
dos2unix /var/www/html/silvestrini/perl/app.pl
chmod -R 755 /var/www/html/silvestrini/perl/app.pl
cp configs/apache/apache-node/perl.conf /etc/apache2/conf-available
dos2unix /etc/apache2/conf-available/perl.conf
cd /etc/apache2/conf-enabled || exit
ln -sf ../conf-available/perl.conf perl.conf

# Restart apache
apachectl configtest
systemctl restart apache2
