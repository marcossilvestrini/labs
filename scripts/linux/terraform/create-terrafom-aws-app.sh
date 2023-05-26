<<'SCRIPT'
    .Synopsis
        Script for up lab
    .DESCRIPTION
        Script for up virtual instance and HTTP App in AWS for learning terraform
    .PREREQUISITES    
        ./aws-functions.sh
    .EXAMPLE
        ./create-terraform-aws-app.sh
SCRIPT

# Set language/locale and encoding
export LANG=C

# Set workdir
WORKDIR="/home/vagrant"
cd $WORKDIR || exit

# Variables
TERRAFORM_PLAN="configs/terraform/aws"

# Import my modules\functions for aws provider
source scripts/linux/aws/aws-functions.sh

# Login in AWS with user\IAM terraform
LoginAWS terraform

# # Create ssh key
# aws ec2 create-key-pair \
#     --key-name gs-ubuntu-key \
#     --key-type ed25519 \
#     --key-format pem \
#     --query "KeyMaterial" \
#     --output text > gs-ubuntu-key.pem

# ssh key pair for aws ec2 instances
echo vagrant | $(su -c "ssh-keygen -o -a 100 -t ed25519 -N '' -f .ssh/id_ed25519 -C "terraform_aws@skynet.com" <<<y >/dev/null 2>&1" -s /bin/bash vagrant)

# Create aws instance ans app for test
cd "$TERRAFORM_PLAN" || exit
terraform init
terraform plan 
terraform apply -auto-approve
