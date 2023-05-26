#!/bin/bash

<<'MULTILINE-COMMENT'
    Requirments: none
    Description: Script for install and configure Docker for labs.
    Author: Marcos Silvestrini
    Date: 17/05/2023
MULTILINE-COMMENT

# Set language/locale and encoding
export LANG=C

# Set workdir
WORKDIR="/home/vagrant"
cd $WORKDIR || exit

# Variables
DISTRO=$(cat /etc/*release | grep -ws NAME=)
DOCKER_APP_NAME="app-http"
DOCKER_APP_DIR="/usr/share/nginx/html"
DOCKER_VOLUME="/docker-volumes/$DOCKER_APP_NAME"
TAG="v1.0.0"
# {{username}}/{{imagename}}:{{version\tag}}
DOCKER_IMAGE="mrsilvestrini/$DOCKER_APP_NAME:$TAG" 
DOCKERFILE="configs/docker/images/$DOCKER_APP_NAME"
DOCKER_VOLUME="$DOCKER_APP_NAME"
DOCKER_VOLUME_FOLDER="/var/lib/docker/volumes/$DOCKER_VOLUME/_data/"
PERSISTENT_FILE="$DOCKER_VOLUME_FOLDER/persistent-file.txt"
JSON="$WORKDIR/security/.docker-secrets"
DOCKERHUB_USERNAME=$(jq -r .username $JSON)
DOCKERHUB_PASSWORD=$(jq -r .password $JSON)    


# Check if distribution is Debian
if [[ "$DISTRO" == *"Debian"* ]]; then    
    echo "Distribution is Debian...Congratulations!!!"
else    
    echo "This script is not available for RPM distrlsibutions!!!";exit 1;
fi

# Install docker

# Add Docker’s official GPG key:
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --yes --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

# Use the following command to set up the repository:
echo \
"deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
"$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine

## Update the apt package index:
apt-get update -y >/dev/null

## Install Docker Engine, containerd, and Docker Compose.
apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y >/dev/null

## Check installation
docker --version

# clear all docker container 
docker container rm $(docker container ls -aq) --force > /dev/null 2>&1
docker volume rm  $DOCKER_VOLUME

# clear all docker images
docker rmi $(docker images -aq) --force > /dev/null 2>&1

# Create .dockerignore
if [ ! -f "$DOCKERFILE/.dockerignore" ]; then
    echo Dockerfile > "$DOCKERFILE/.dockerignore"    
fi

# Build my custom image
docker build -q -t "$DOCKER_IMAGE" --build-arg DOCKER_APP_DIR="$DOCKER_APP_DIR"  "$DOCKERFILE"

# Push image to docker hub

## Login dockerhub account
echo "$DOCKERHUB_PASSWORD" | docker login -u "$DOCKERHUB_USERNAME" --password-stdin docker.io > /dev/null 2>&1

## Push image to docker hub
docker push -q "$DOCKER_IMAGE"

# pull image from docker
docker pull $DOCKER_IMAGE

# Create a container with custom image for testing purposes

## Create container with docker volume

docker run -d --name $DOCKER_APP_NAME \
    --mount source=$DOCKER_VOLUME,target=$DOCKER_APP_DIR \
    -p 8080:80 $DOCKER_IMAGE

## Create persistent file for test volume
if [ ! -f "$PERSISTENT_FILE" ]; then
    date=$(date '+%Y-%m-%d %H:%M:%S')
    echo "Date: $date" > "$PERSISTENT_FILE"
    echo "Test persistet file in docker volume!!!" >> $PERSISTENT_FILE    
fi

# Logout dockerhub according
docker logout
