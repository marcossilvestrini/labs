#!/bin/bash

<<'MULTILINE-COMMENT'
    Requirments: none
    Description: Script for aws automations
    Author: Marcos Silvestrini
    Date: 18/05/2023
MULTILINE-COMMENT

# Set language/locale and encoding
export LANG=C

# Scriptpath
path=$(readlink -f "${BASH_SOURCE:-$0}")
DIR_PATH=$(dirname "$path")

# Log functions
LOGFUNCTIONS="$DIR_PATH/aws-functions.log"
echo "############### Begin Log ###################" >"$LOGFUNCTIONS"
date=$(date '+%Y-%m-%d %H:%M:%S')
echo "Date: $date" >>"$LOGFUNCTIONS"

# Variables
cd $DIR_PATH
cd ../../../
JSON=security/.aws-secrets
export AWS_DEFAULT_REGION="us-east-1"

# Functio for login in Azure Portal
LoginAWS() {
    IAM_USERNAME="$1"
    if [ -z "$IAM_USERNAME" ]; then
        echo "Not found parameter. Please user LoginAWS <aws_iam_username>"

    else
        echo "Set credential for user $IAM_USERNAME"
        echo "Set credential for user $IAM_USERNAME" >>"$LOGFUNCTIONS"
        case $IAM_USERNAME in
        "terraform")
            export AWS_ACCESS_KEY_ID=$(jq -r .terraform_access_key $JSON)
            export AWS_SECRET_ACCESS_KEY=$(jq -r .terraform_secret_key $JSON)
            ;;
        "ansible")
            export AWS_ACCESS_KEY_ID=$(jq -r .ansible_access_key $JSON)
            export AWS_SECRET_ACCESS_KEY=$(jq -r .ansible_secret_key $JSON)
            ;;
        *)
            echo "AWS IAM not found. Please check your credentials in AWS console!!!!"            
            ;;
        esac
        LOGIN="$(aws iam list-users | jq -r .Users[].UserName)"
        if [ "$LOGIN" == "$IAM_USERNAME" ]; then
            echo "Login in AWS with IAM [$IAM_USERNAME:$LOGIN] has successfully!!!"
            echo "Login in AWS with IAM [$IAM_USERNAME:$LOGIN] has successfully!!!" >>"$LOGFUNCTIONS"
            echo "----------------------------------------------------"
        else
            echo "Login in AWS with IAM [$IAM_USERNAME:$LOGIN] failed. This IAM user not found in AWS account. Please check in AWS Console"
            echo "Login in AWS with IAM [$IAM_USERNAME:$LOGIN] failed. This IAM user not found in AWS account. Please check in AWS Console" >>"$LOGFUNCTIONS"
            echo "----------------------------------------------------"
        fi
    fi

}
