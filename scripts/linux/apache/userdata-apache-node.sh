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
mkdir -p /etc/apache2/logs

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
#sed -i "s/var_ip/$PRIVATE_IP/g" /etc/apache2/sites-available/000-default.conf
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

# Set sites with autentication rules(mod_authn)
mkdir -p {/var/www/html/topsecret,/var/www/html/admin}
touch /var/www/html/topsecret/topsecret_file{1..3}
touch /var/www/html/admin/admin_file{1..3}
cp configs/apache/security/.htaccess /var/www/html/topsecret
cp configs/apache/security/.htaccess /var/log/apache2
chmod -R 755 /var/log/apache2
dos2unix /var/www/html/topsecret/.htaccess
dos2unix /var/log/apache2/.htaccess

# Set sites with autorization rules (mod_authz)
cp configs/apache/security/.htaccess_admin /var/www/html/admin/.htaccess
dos2unix /var/www/html/admin/.htaccess

# Create Main Site - www.skynet.com.br and set: Virtualhost, alias and redirects
mkdir -p /var/www/html
cp -f configs/apache/html/index.html /var/www/html/
sed -i "s/var_ip/$PRIVATE_IP/g" "/var/www/html/index.html"
sed -i "s/var_hostname/$MACHINE_NAME/g" "/var/www/html/index.html"
dos2unix /var/www/html/index.html

# Create Main \Silvestrini\ and set: Virtualhost, alias and redirects
cp configs/apache/apache-node/silvestrini.conf /etc/apache2/sites-available
dos2unix /etc/apache2/sites-available/silvestrini.conf
chmod 644 /etc/apache2/sites-available/silvestrini.conf
a2ensite silvestrini.conf
mkdir {/var/www/html/silvestrini,/var/www/html/silvestrini/music,/var/www/html/silvestrini/store}

## Site silvestrini.skynet.com.br
cp configs/apache/html/index-main.html /var/www/html/silvestrini/index.html
sed -i "s/var_ip/$PRIVATE_IP/g" "/var/www/html/silvestrini/index.html"
sed -i "s/var_hostname/$MACHINE_NAME/g" "/var/www/html/silvestrini/index.html"
mkdir /var/www/html/silvestrini/docs
touch /var/www/html/skynet/docs/doc{1..6}

## Site music.skynet.com.br
cp configs/apache/html/index-music.html /var/www/html/silvestrini/music/index.html
sed -i "s/var_ip/$PRIVATE_IP/g" "/var/www/html/silvestrini/music/index.html"
sed -i "s/var_hostname/$MACHINE_NAME/g" "/var/www/html/silvestrini/music/index.html"

## Site store.skynet.com.br
cp configs/apache/html/index-store.html /var/www/html/silvestrini/store/index.html
sed -i "s/var_ip/$PRIVATE_IP/g" "/var/www/html/silvestrini/store/index.html"
sed -i "s/var_hostname/$MACHINE_NAME/g" "/var/www/html/silvestrini/store/index.html"

# Create Main Finance and set: Virtualhost, alias and redirects
cp configs/apache/apache-proxy/site-finance.conf /etc/httpd/conf.d/
dos2unix /etc/httpd/conf.d/site-finance.conf
chmod 644 /etc/httpd/conf.d/site-finance.conf
sed -i "s/var_ip/$PRIVATE_IP/g" "/etc/httpd/conf.d/site-finance.conf"

## Create site - finance.skynet.com.br
mkdir /var/www/html/finance
cp configs/apache/apache-proxy/index-finance.html /var/www/html/finance/index.html
sed -i "s/var_ip/$PRIVATE_IP/g" "/var/www/html/finance/index.html"
sed -i "s/var_hostname/$MACHINE_NAME/g" "/var/www/html/finance/index.html"

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
