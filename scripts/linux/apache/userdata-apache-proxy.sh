#!/bin/bash

<<'MULTILINE-COMMENT'
    Requirments: none
    Description: Script for configure apache proxy
    Author: Marcos Silvestrini
    Date: 18/04/2023
MULTILINE-COMMENT

export LANG=C

#Variables
PRIVATE_IP=$(ip add show | grep 192.168.0 | cut -c 10-22)
MACHINE_NAME=$(hostname -f)

cd /home/vagrant || exit

# Install Apache
dnf install -y policycoreutils-python-utils
dnf install -y httpd
dnf install -y mod_ssl
dnf install -y gnutls-utils
dnf install -y ca-certificates

# Tunning apache

## Configure /etc/httpd/conf/httpd.conf
#-rw-r--r--. 1 root root 12005 Oct  6 07:39 /etc/httpd/conf/httpd.conf
cp -p /etc/httpd/conf/httpd.conf configs/apache/apache-proxy/httpd.conf_backup
cp -f configs/apache/apache-proxy/httpd.conf /etc/httpd/conf/
dos2unix /etc/httpd/conf/httpd.conf
chmod 644 /etc/httpd/conf/httpd.conf
sed -i "s/var_ip/$PRIVATE_IP/g" /etc/httpd/conf/httpd.conf

## Configure MPM mod
cp -f configs/apache/apache-proxy/00-mpm.conf /etc/httpd/conf.modules.d
dos2unix /etc/httpd/conf.modules.d/00-mpm.conf
chmod 644 /etc/httpd/conf.modules.d/00-mpm.conf

# Create user autentication db for sites
mkdir /etc/httpd/htpasswd
echo "vagrant" | htpasswd -c -i /etc/httpd/htpasswd/.htpasswd vagrant
echo "silvestrini" | htpasswd -i /etc/httpd/htpasswd/.htpasswd silvestrini
echo "skynet" | htpasswd -i /etc/httpd/htpasswd/.htpasswd skynet
cp  configs/apache/security/.htgroup /etc/httpd/htpasswd
dos2unix /etc/httpd/htpasswd/.htgroup

# Set sites with autentication rules(mod_authn)
mkdir {/var/www/html/topsecret,/var/www/html/admin}
touch /var/www/html/topsecret/topsecret_file{1..3}
touch /var/www/html/admin/admin_file{1..3}
cp configs/apache/security/.htaccess /var/www/html/topsecret
cp configs/apache/security/.htaccess /var/log/httpd
chmod 755 /var/log/httpd/
dos2unix /var/www/html/topsecret/.htaccess
dos2unix /var/log/httpd/.htaccess

# Set sites with autorization rules (mod_authz)
cp configs/apache/security/.htaccess_admin /var/www/html/admin/.htaccess
dos2unix /var/www/html/admin/.htaccess

# Create Main Site - www.skynet.com.br and set: Virtualhost, alias and redirects
cp -f configs/apache/html/index.html /var/www/html/
sed -i "s/var_ip/$PRIVATE_IP/g" "/var/www/html/index.html"
sed -i "s/var_hostname/$MACHINE_NAME/g" "/var/www/html/index.html"
dos2unix /var/www/html/index.html

# Create Main \Silvestrini\ and set: Virtualhost, alias and redirects
cp configs/apache/apache-proxy/silvestrini.conf /etc/httpd/conf.d/
dos2unix /etc/httpd/conf.d/silvestrini.conf
chmod 644 /etc/httpd/conf.d/silvestrini.conf
sed -i "s/var_ip/$PRIVATE_IP/g" "/etc/httpd/conf.d/silvestrini.conf"
mkdir {/var/www/html/silvestrini,/var/www/html/silvestrini/music,/var/www/html/silvestrini/store}

## Site silvestrini.skynet.com.br
cp configs/apache/html/index-main.html /var/www/html/silvestrini/index.html
sed -i "s/var_ip/$PRIVATE_IP/g" "/var/www/html/silvestrini/index.html"
sed -i "s/var_hostname/$MACHINE_NAME/g" "/var/www/html/silvestrini/index.html"
mkdir /var/www/html/silvestrini/docs
touch /var/www/html/silvestrini/docs/doc{1..6}

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
dnf install -y php-{common,gmp,fpm,curl,intl,pdo,mbstring,gd,xml,cli,zip,mysqli}
mkdir /var/www/html/silvestrini/php
cp -f configs/apache/backend/info.php /var/www/html/silvestrini/php
dos2unix /var/www/html/silvestrini/php/info.php

# Install perl app (https://techexpert.tips/apache/perl-cgi-apache/)
dnf install -y perl
cp configs/apache/apache-proxy/perl.conf /etc/httpd/conf.d/
dos2unix /etc/httpd/conf.d/perl.conf
chmod 644 /etc/httpd/conf.d/perl.conf
mkdir /var/www/html/silvestrini/perl
cp configs/apache/backend/app.pl /var/www/html/silvestrini/perl
dos2unix /var/www/html/silvestrini/perl/app.pl
chmod -R 755 /var/www/html/silvestrini/perl/app.pl

# Reload Daemon(for systemctl units only)
systemctl daemon-reload

# Update trusted certificates
update-ca-trust

# Restart apache service
apachectl configtest
apachectl restart
