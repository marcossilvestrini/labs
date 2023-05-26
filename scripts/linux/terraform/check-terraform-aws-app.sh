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

#Variables
TERRAFORM_PLAN="configs/terraform"
AWS_PUBLIC_IP="$(terraform output -state="$TERRAFORM_PLAN/terraform.tfstate"  -json | jq -r .instance_ips.value)"
URL_HTTP_APP="http://$AWS_PUBLIC_IP:8080"


# File for outputs testing
FILE_TEST=test/terraform/check-terraform-aws-app.txt
LINE="------------------------------------------------------"

echo $LINE >$FILE_TEST
echo "Check AWS HTTP App for This Lab" >>$FILE_TEST
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "Date: $DATE" >>$FILE_TEST
echo -e "$LINE\n" >>$FILE_TEST

# Check HTTP App Status
echo -e "Check AWS HTTP App Status...\n" >>$FILE_TEST
echo -e "Site: $URL_HTTP_APP" >>$FILE_TEST
STATUS_CODE=$(curl -LI "$URL_HTTP_APP" -o /dev/null -w '%{http_code}\n' -s)
BODY=$(curl -s "$URL_HTTP_APP")
echo "Status Code: $STATUS_CODE" >>$FILE_TEST
echo "Body: $BODY" >>$FILE_TEST
echo -e "$LINE\n" >>$FILE_TEST
