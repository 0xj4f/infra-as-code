#!/bin/bash
set -e

# Variables
IAM_USERNAME="aws.admin"
POLICY_ARN="arn:aws:iam::aws:policy/AdministratorAccess"

# Create a new IAM user
aws iam create-user --user-name $IAM_USERNAME

# Attach the policy to the user
aws iam attach-user-policy --user-name $IAM_USERNAME --policy-arn $POLICY_ARN

echo "User $IAM_USERNAME created with policy $POLICY_ARN"

# Create access keys for the user
aws iam create-access-key --user-name $IAM_USERNAME | tee aws-acess-keys.json
