#!/bin/bash


AMI_ID="ami-0df7a207adb9748c7" # UBUNTU 22.04 
INSTANCE_TYPE="t2.medium"
KEY_NAME="demo-key" # must be existing in aws already
SECURITY_GROUP="sg-xxxxxxxxxxxx" 
SUBNET_ID="subnet-xxxxxxxxxxxxx"
VOLUME_SIZE=50  # 50GB

INSTANCE_NAME=$1

if [ -z "$INSTANCE_NAME" ]; then
    echo "Error: No instance name provided."
    echo "Usage: $0 <instance_name>"
    exit 1
fi

set -x
INSTANCE_ID=$(aws ec2 run-instances \
    --image-id $AMI_ID \
    --count 1 \
    --instance-type $INSTANCE_TYPE \
    --key-name $KEY_NAME \
    --security-group-ids $SECURITY_GROUP \
    --subnet-id $SUBNET_ID \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$INSTANCE_NAME}]" \
    --block-device-mappings "[{\"DeviceName\":\"/dev/sda1\",\"Ebs\":{\"VolumeSize\":$VOLUME_SIZE}}]" \
    --query 'Instances[0].InstanceId' \
    --output text)



# Wait for the instance to be in the running state
echo "[+] Waiting for $INSTANCE_ID to run"
aws ec2 wait instance-running --instance-ids $INSTANCE_ID

# Allocate a new Elastic IP
ALLOC_ID=$(aws ec2 allocate-address \
    --domain vpc \
    --query 'AllocationId' \
    --output text)

# Associate the Elastic IP with the instance
aws ec2 associate-address \
    --instance-id $INSTANCE_ID \
    --allocation-id $ALLOC_ID
