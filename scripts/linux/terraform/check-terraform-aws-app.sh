#!/bin/bash
<<'SCRIPT-FUNCTION'
    Description: Script for check HTTP App in AWS instance 
    Author: Marcos Silvestrini
    Date: 23/05/2023
SCRIPT-FUNCTION

#Set localizations for prevent bugs in operations
LANG=C

# Set workdir
WORKDIR="/home/vagrant"
cd $WORKDIR || exit

# Destroy instance in aws

# Import my modules\functions for aws provider
source scripts/linux/aws/aws-functions.sh

## Login in AWS with user\IAM terraform
LoginAWS terraform

#Variables
TERRAFORM_PLAN="configs/terraform/aws"
AWS_PUBLIC_IP="$(terraform output -state="$TERRAFORM_PLAN/terraform.tfstate"  -json | jq -r .web_instance_ip.value)"
URL_HTTP_APP="http://$AWS_PUBLIC_IP"


# File for outputs testing
FILE_TEST=test/terraform/check-terraform-aws-app.txt
LINE="------------------------------------------------------"

echo $LINE >$FILE_TEST
echo "Check Terraform AWS HTTP App for This Lab" >>$FILE_TEST
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "Date: $DATE" >>$FILE_TEST
echo -e "$LINE\n" >>$FILE_TEST

#Check if instance is running
EC2_STATUS="starting"
COUNT=0
TIMEOUT=30
echo "Waiting for aws ec2 instance up..."
while [ "$EC2_STATUS" != "running" ]
do    
    echo "Waiting for aws ec2 instance up...STATUS:[$EC2_STATUS]"
    EC2_STATUS="$(aws ec2 describe-instance-status | jq -r .InstanceStatuses[].InstanceState.Name)"    
    sleep 1
    ((COUNT++))    
    if (( COUNT > TIMEOUT )); then
        break;
    fi    
done

# Check HTTP App Status
echo -e "Check AWS HTTP App Status...\n" >>$FILE_TEST
echo -e "Site: $URL_HTTP_APP" >>$FILE_TEST
STATUS_CODE=$(curl -LI "$URL_HTTP_APP" -o /dev/null -w '%{http_code}\n' -s)
BODY=$(curl -s "$URL_HTTP_APP" | grep "Silvestrini" )
echo "Status Code: $STATUS_CODE" >>$FILE_TEST
echo "Body: $BODY" >>$FILE_TEST
echo -e "$LINE\n" >>$FILE_TEST
