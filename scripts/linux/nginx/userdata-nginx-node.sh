#!/bin/bash

<<'MULTILINE-COMMENT'
    Requirments: none
    Description: Script for configure nginx
    Author: Marcos Silvestrini
    Date: 25/04/2023
MULTILINE-COMMENT

export LANG=C

#Variables
PRIVATE_IP=$(ip add show | grep 192.168.0 | cut -c 10-22)
MACHINE_NAME=$(hostname -f)
NODE=$(hostname | cut -c 14-16)

cd /home/vagrant || exit

# Install nginx
apt install -y nginx apache2-utils

# Copy certificates from server ol9-server01 to local machine
sshpass -p "vagrant" sudo  scp -o StrictHostKeyChecking=no vagrant@ol9-server02:/etc/ssl/certs/skynet* /etc/ssl/certs

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

# Tunning nginx

# Configure /etc/nginx/nginx.conf
#-rw-r--r--. 1 root root 2334 Oct  6 18:24 /etc/nginx/nginx.conf
cp -p /etc/nginx/nginx.conf configs/nginx/nginx-node/nginx.conf_backup
cp -f configs/nginx/nginx-node/nginx.conf /etc/nginx/
dos2unix /etc/nginx/nginx.conf
chmod 644 /etc/nginx/nginx.conf
sed -i "s/var_hostname/$MACHINE_NAME/g" "/etc/nginx/nginx.conf"

# Create user autentication db for sites
mkdir -p /etc/httpd/htpasswd
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
cp configs/nginx/nginx-node/silvestrini.conf /etc/nginx/conf.d/
dos2unix /etc/nginx/conf.d/silvestrini.conf
chmod 644 /etc/nginx/conf.d/silvestrini.conf
sed -i "s/VAR_NODE/$NODE/g" "/etc/nginx/conf.d/silvestrini.conf"
cp configs/nginx/html/index-silvestrini.html /var/www/html/silvestrini/index.html
sed -i "s/var_ip/$PRIVATE_IP/g" "/var/www/html/silvestrini/index.html"
sed -i "s/var_hostname/$MACHINE_NAME/g" "/var/www/html/silvestrini/index.html"


# ## Site music.skynet.com.br
mkdir /var/www/html/music
cp configs/nginx/nginx-node/music.conf /etc/nginx/conf.d/
dos2unix /etc/nginx/conf.d/music.conf
chmod 644 /etc/nginx/conf.d/music.conf
sed -i "s/VAR_NODE/$NODE/g" "/etc/nginx/conf.d/music.conf"
cp configs/nginx/html/index-music.html /var/www/html/music/index.html
sed -i "s/var_ip/$PRIVATE_IP/g" "/var/www/html/music/index.html"
sed -i "s/var_hostname/$MACHINE_NAME/g" "/var/www/html/music/index.html"

## Site store.skynet.com.br
mkdir /var/www/html/store
cp configs/nginx/nginx-node/store.conf /etc/nginx/conf.d/
dos2unix /etc/nginx/conf.d/store.conf
chmod 644 /etc/nginx/conf.d/store.conf
sed -i "s/VAR_NODE/$NODE/g" "/etc/nginx/conf.d/store.conf"
cp configs/nginx/html/index-store.html /var/www/html/store/index.html
sed -i "s/var_ip/$PRIVATE_IP/g" "/var/www/html/store/index.html"
sed -i "s/var_hostname/$MACHINE_NAME/g" "/var/www/html/store/index.html"

# Install php app
apt install -y php php-fpm
mkdir /var/www/html/silvestrini/php
cp -f configs/nginx/backend/info.php /var/www/html/silvestrini/php
dos2unix /var/www/html/silvestrini/php/info.php

# Install perl app 
# https://www.server-world.info/en/note?os=Debian_11&p=nginx&f=8

## Install packges
apt -y install fcgiwrap

## Configure locations
mkdir /var/www/html/silvestrini/perl
chmod 755 /var/www/html/silvestrini/perl

## Configure perl app for test
cp configs/nginx/backend/app.pl /var/www/html/silvestrini/perl
dos2unix /var/www/html/silvestrini/perl/app.pl
chmod -R 755 /var/www/html/silvestrini/perl/app.pl

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

# Enable perl service
# systemctl enable fcgiwrap

# Restart ngix service
systemctl restart nginx

# Restart fcgiwrap service
#systemctl restart fcgiwrap