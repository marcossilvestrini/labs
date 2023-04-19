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
chmod 755 -R /var/log/httpd/


# Create Main Site - www.skynet.com.br and set: Virtualhost, alias and redirects
cp -f configs/apache/html/index.html /var/www/html/
sed -i "s/var_ip/$PRIVATE_IP/g" "/var/www/html/index.html"
sed -i "s/var_hostname/$MACHINE_NAME/g" "/var/www/html/index.html"
dos2unix /var/www/html/index.html

# Create silvestrini.skynet.com.br and set: Virtualhost, alias and redirects
mkdir -p {/var/www/html/silvestrini,/var/www/html/silvestrini/docs}
touch /var/www/html/silvestrini/docs/"$(hostname)"
touch /var/www/html/silvestrini/docs/doc{1..6}
cp configs/apache/apache-proxy/silvestrini.conf /etc/httpd/conf.d/
dos2unix /etc/httpd/conf.d/silvestrini.conf
chmod 644 /etc/httpd/conf.d/silvestrini.conf
sed -i "s/var_ip/$PRIVATE_IP/g" "/etc/httpd/conf.d/silvestrini.conf"
cp configs/apache/html/index-silvestrini.html /var/www/html/silvestrini/index.html
sed -i "s/var_ip/$PRIVATE_IP/g" "/var/www/html/silvestrini/index.html"
sed -i "s/var_hostname/$MACHINE_NAME/g" "/var/www/html/silvestrini/index.html"


## Site music.skynet.com.br
mkdir -p /var/www/html/music
cp configs/apache/apache-proxy/music.conf /etc/httpd/conf.d/
dos2unix /etc/httpd/conf.d/music.conf
chmod 644 /etc/httpd/conf.d/music.conf
sed -i "s/var_ip/$PRIVATE_IP/g" "/etc/httpd/conf.d/music.conf"
cp configs/apache/html/index-music.html /var/www/html/music/index.html
sed -i "s/var_ip/$PRIVATE_IP/g" "/var/www/html/music/index.html"
sed -i "s/var_hostname/$MACHINE_NAME/g" "/var/www/html/music/index.html"

## Site store.skynet.com.br
mkdir -p /var/www/html/store
cp configs/apache/apache-proxy/store.conf /etc/httpd/conf.d/
dos2unix /etc/httpd/conf.d/store.conf
chmod 644 /etc/httpd/conf.d/store.conf
sed -i "s/var_ip/$PRIVATE_IP/g" "/etc/httpd/conf.d/store.conf"
cp configs/apache/html/index-store.html /var/www/html/store/index.html
sed -i "s/var_ip/$PRIVATE_IP/g" "/var/www/html/store/index.html"
sed -i "s/var_hostname/$MACHINE_NAME/g" "/var/www/html/store/index.html"

## Site - finance.skynet.com.br
mkdir -p /var/www/html/finance
cp configs/apache/apache-proxy/finance.conf /etc/httpd/conf.d/
dos2unix /etc/httpd/conf.d/finance.conf
chmod 644 /etc/httpd/conf.d/finance.conf
sed -i "s/var_ip/$PRIVATE_IP/g" "/etc/httpd/conf.d/finance.conf"
cp configs/apache/html/index-finance.html /var/www/html/finance/index.html
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
