#!/bin/bash
set -e

# Variables
IAM_USERNAME="aws.email"
POLICY_ARN="arn:aws:iam::aws:policy/AmazonSESFullAccess"

# Create a new IAM user
aws iam create-user --user-name $IAM_USERNAME | tee $IAM_USERNAME-aws-user.json

# Attach the policy to the user
aws iam attach-user-policy --user-name $IAM_USERNAME --policy-arn $POLICY_ARN

echo "User $IAM_USERNAME created with policy $POLICY_ARN"

aws iam create-access-key --user-name $IAM_USERNAME | tee $IAM_USERNAME-aws-access-keys.json
