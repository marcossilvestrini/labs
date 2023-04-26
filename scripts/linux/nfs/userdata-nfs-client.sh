#!/bin/bash

<<'MULTILINE-COMMENT'
    Requirments: none
    Description: Script for set environment for labs
    Author: Marcos Silvestrini
    Date: 24/03/2023
MULTILINE-COMMENT

export LANG=C

cd /home/vagrant || exit

# Variables
DISTRO=$(cat /etc/*release | grep -ws NAME=)

# Install NFS Client
if [[ $DISTRO == *"Debian"* ]]; then
    apt-get install -y nfs-common
else
    dnf install -y nfs-utils
fi

# Mount Share in /etc/fstab
#-rw-r--r-- 1 root root 652 Mar 24 10:25 /etc/fstab
VM=$(hostname)

## Copy original template for fstab
if [ ! -f "configs/nfs/fstab_${VM}_backup" ]; then        
        cp /etc/fstab "configs/nfs/fstab_${VM}_backup"
fi

# Check fstab uuid
UUID_SERVER=$(echo $(cat /etc/fstab | grep "UUID=") | cut -d' ' -f1)
UUID_LOCAL=$(echo $(cat "configs/nfs/fstab_${VM}_backup" | grep "UUID=") | cut -d' ' -f1)

if [ "$UUID_SERVER" = "$UUID_LOCAL" ]; then
    echo "UUIDS its ok for deploy"
    echo "UUID Server: $UUID_SERVER"
    echo "UUID Local: $UUID_LOCAL"
else
    echo "ERROR!!! UUIDS not equals."
    echo "We will Copy a nem /etc/fstab for deply,relax guy!!!"
    rm "configs/nfs/fstab_${VM}_backup"
    cp /etc/fstab "configs/nfs/fstab_${VM}_backup"
fi

## Generate fstab with nfs\cifs shares
if [ -f "configs/nfs/fstab"  ];then
    rm "configs/nfs/fstab"
fi
cp "configs/nfs/fstab_${VM}_backup" configs/nfs/fstab
cat configs/nfs/cifs-shares >> configs/nfs/fstab
cp configs/nfs/fstab /etc/fstab
dos2unix /etc/fstab
chmod 644 /etc/fstab  

## Mount NFS shares server ol9-server01
mkdir -p {/mnt/nfs-ol9-server01-home,/mnt/nfs-ol9-server01-logs,/mnt/nfs-ol9-server01-etc}
mount /mnt/nfs-ol9-server01-home
mount /mnt/nfs-ol9-server01-logs
mount /mnt/nfs-ol9-server01-etc

## Mount NFS shares server debian-server01
mkdir -p {/mnt/nfs-debian-server01-home,/mnt/nfs-debian-server01-logs,/mnt/nfs-debian-server01-etc}
mount /mnt/nfs-debian-server01-home
mount /mnt/nfs-debian-server01-logs
mount /mnt/nfs-debian-server01-etc