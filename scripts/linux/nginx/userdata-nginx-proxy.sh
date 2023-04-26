#!/bin/bash

<<'MULTILINE-COMMENT'
    Requirments: none
    Description: Script for configure NGINX
    Author: Marcos Silvestrini
    Date: 14/04/2023
MULTILINE-COMMENT

export LANG=C

#Variables
PRIVATE_IP=$(ip add show | grep 192.168.0 | cut -c 10-22)
MACHINE_NAME=$(hostname -f)

cd /home/vagrant || exit

# Install Nginx
dnf install -y nginx
dnf install -y php php-fpm

# Remove old www files
if [ -d "/var/www/html" ]; then
    rm -rf /var/www/html
fi

# Remove old /etc/nginx/conf.d files
FILES="
/etc/nginx/conf.d/silvestrini.conf
/etc/nginx/conf.d/music.conf
/etc/nginx/conf.d/store.conf
/etc/nginx/conf.d/finance.conf"

 for f in $FILES
 do 
   if [ -f "$f" ]; then
     echo "Delete file $f ..."
     rm -f "$f"
   else
     echo "Warning: Some problem with \"$f\""
   fi
 done


# Set permissions
chmod -R 775  /var/log/nginx

# Tunning Nginx

# Configure /etc/nginx/nginx.conf
#-rw-r--r--. 1 root root 2334 Oct  6 18:24 /etc/nginx/nginx.conf
cp -p /etc/nginx/nginx.conf configs/nginx/nginx-proxy/nginx.conf_backup
cp -f configs/nginx/nginx-proxy/nginx.conf /etc/nginx/
dos2unix /etc/nginx/nginx.conf
chmod 644 /etc/nginx/nginx.conf

# Create user autentication db for sites
mkdir /etc/httpd/htpasswd
echo "vagrant" | htpasswd -c -i /etc/httpd/htpasswd/.htpasswd vagrant
echo "silvestrini" | htpasswd -i /etc/httpd/htpasswd/.htpasswd silvestrini
echo "skynet" | htpasswd -i /etc/httpd/htpasswd/.htpasswd skynet
cp  configs/nginx/security/.htgroup /etc/httpd/htpasswd
dos2unix /etc/httpd/htpasswd/.htgroup

# Create www.skynet.com.br/topsecret
mkdir -p /var/www/html/topsecret
touch /var/www/html/topsecret/"$(hostname)"
touch /var/www/html/topsecret/topsecret_file{1..3}

# Create www.skynet.com.br/admin
mkdir -p /var/www/html/admin
touch /var/www/html/admin/"$(hostname)"
touch /var/www/html/admin/admin_file{1..3}

# Create Main Site - www.skynet.com.br and set: Virtualhost, alias and redirects
cp -f configs/nginx/html/index.html /var/www/html/
sed -i "s/var_ip/$PRIVATE_IP/g" "/var/www/html/index.html"
sed -i "s/var_hostname/$MACHINE_NAME/g" "/var/www/html/index.html"
dos2unix /var/www/html/index.html

# Create silvestrini.skynet.com.br and set: Virtualhost, alias and redirects
mkdir -p {/var/www/html/silvestrini,/var/www/html/silvestrini/docs}
touch /var/www/html/silvestrini/docs/"$(hostname)"
touch /var/www/html/silvestrini/docs/doc{1..6}
cp configs/nginx/nginx-proxy/silvestrini.conf /etc/nginx/conf.d/
dos2unix /etc/nginx/conf.d/silvestrini.conf
chmod 644 /etc/nginx/conf.d/silvestrini.conf
cp configs/nginx/html/index-silvestrini.html /var/www/html/silvestrini/index.html
sed -i "s/var_ip/$PRIVATE_IP/g" "/var/www/html/silvestrini/index.html"
sed -i "s/var_hostname/$MACHINE_NAME/g" "/var/www/html/silvestrini/index.html"


## Site music.skynet.com.br
mkdir /var/www/html/music
cp configs/nginx/nginx-proxy/music.conf /etc/nginx/conf.d/
dos2unix /etc/nginx/conf.d/music.conf
chmod 644 /etc/nginx/conf.d/music.conf
cp configs/nginx/html/index-music.html /var/www/html/music/index.html
sed -i "s/var_ip/$PRIVATE_IP/g" "/var/www/html/music/index.html"
sed -i "s/var_hostname/$MACHINE_NAME/g" "/var/www/html/music/index.html"

## Site store.skynet.com.br
mkdir /var/www/html/store
cp configs/nginx/nginx-proxy/store.conf /etc/nginx/conf.d/
dos2unix /etc/nginx/conf.d/store.conf
chmod 644 /etc/nginx/conf.d/store.conf
cp configs/nginx/html/index-store.html /var/www/html/store/index.html
sed -i "s/var_ip/$PRIVATE_IP/g" "/var/www/html/store/index.html"
sed -i "s/var_hostname/$MACHINE_NAME/g" "/var/www/html/store/index.html"

# Install php app
dnf install -y php-{common,gmp,fpm,curl,intl,pdo,mbstring,gd,xml,cli,zip,mysqli}
mkdir /var/www/html/silvestrini/php
cp -f configs/nginx/backend/info.php /var/www/html/silvestrini/php
dos2unix /var/www/html/silvestrini/php/info.php

# Install perl app (https://techexpert.tips/nginx/perl-cgi-nginx/)

## Install packges
dnf install -y perl fcgiwrap

## Configure locations
mkdir /var/www/html/silvestrini/perl
chmod 755 /var/www/html/silvestrini/perl

## Configure perl app for test
cp configs/nginx/backend/app.pl /var/www/html/silvestrini/perl
dos2unix /var/www/html/silvestrini/perl/app.pl
chmod -R 755 /var/www/html/silvestrini/perl/app.pl

## Configure fastCGI
cp configs/nginx/nginx-proxy/fcgiwrap.service /usr/lib/systemd/system
dos2unix /usr/lib/systemd/system/fcgiwrap.service
cp configs/nginx/nginx-proxy/fcgiwrap.socket /usr/lib/systemd/system
dos2unix /usr/lib/systemd/system/fcgiwrap.socket

# Configure HTML maintenance pages
cp -r configs/nginx/images /var/www/html/
cp configs/nginx/html/404.html /var/www/html
cp configs/nginx/html/404.html /var/www/html/silvestrini
cp configs/nginx/html/404.html /var/www/html/music
cp configs/nginx/html/404.html /var/www/html/store
cp configs/nginx/html/404.html /var/www/html/finance
cp configs/nginx/html/50x.html /var/www/html
cp configs/nginx/html/50x.html /var/www/html/silvestrini
cp configs/nginx/html/50x.html /var/www/html/music
cp configs/nginx/html/50x.html /var/www/html/store
cp configs/nginx/html/50x.html /var/www/html/finance


# Check nginx configuration
nginx -t

# Enable ngix service
systemctl enable nginx

# Enable php service
systemctl enable php-fpm

# Enable perl service
systemctl enable fcgiwrap

# Restart ngix service
systemctl restart nginx
systemctl restart php-fpm
systemctl restart fcgiwrap