#!/bin/bash
<<'SCRIPT-FUNCTION'
    Description: Script for destroy HTTP App in AWS instance
    Author: Marcos Silvestrini
    Date: 23/05/2023
SCRIPT-FUNCTION

#Set localizations for prevent bugs in operations
LANG=C

# Set workdir
WORKDIR="/home/vagrant"
cd $WORKDIR || exit

#Variables
TERRAFORM_PLAN="configs/terraform"

# Destroy instance in aws

# Import my modules\functions for aws provider
source scripts/linux/aws/aws-functions.sh

## Login in AWS with user\IAM terraform
LoginAWS terraform

## destroy instance
cd "$TERRAFORM_PLAN" || exit
terraform destroy -auto-approve
