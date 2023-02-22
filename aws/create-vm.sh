#!/bin/bash

# Set variables
region="us-east-2"
vmname="jaflabs"
os="ubuntu-20.04"
instance_type="c5.2xlarge"
key_name="pyotir"

# Generate SSH key pair
echo "Generating SSH key pair..."
ssh-keygen -t rsa -b 4096 -C "$key_name" -f "$key_name" -N ""

# Import SSH public key to AWS
echo "Importing SSH public key to AWS..."
aws ec2 import-key-pair --key-name "$key_name" --public-key-material file://"$key_name.pub" --region "$region"

# Create EC2 instance
echo "Creating EC2 instance..."
instance_id=$(aws ec2 run-instances \
  --image-id "$os" \
  --count 1 \
  --instance-type "$instance_type" \
  --key-name "$key_name" \
  --security-group-ids "$(aws ec2 describe-security-groups --group-names default --query 'SecurityGroups[0].GroupId' --output text --region "$region")" \
  --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value='"$vmname"'}]' \
  --user-data file://user-data.sh \
  --query 'Instances[0].InstanceId' \
  --output text \
  --region "$region")

echo "Instance created with ID: $instance_id"
