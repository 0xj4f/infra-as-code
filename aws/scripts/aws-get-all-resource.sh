#!/bin/bash
set -x
REGION=us-east-2
# List of AWS resources to check
resource_types=(
    "ec2:instance"
    "lambda:function"
    "rds:db"
    "s3:bucket"
    "dynamodb:table"
    "ecs:service"
)

# Loop through each resource type and get active resources
for resource_type in "${resource_types[@]}"; do
    echo "Checking ${resource_type} resources..."
    resources=$(aws resourcegroupstaggingapi get-resources --region us-east-2 --resource-type-filters "AWS::${resource_type}" --query 'length(ResourceTagMappingList[].ResourceARN)' --output text)
    if [ "${resources}" -gt "0" ]; then
        echo "Found ${resources} active resources of type ${resource_type}:"
        aws resourcegroupstaggingapi get-resources --region us-east-2 --resource-type-filters "AWS::${resource_type}" --query 'ResourceTagMappingList[].{ARN: ResourceARN, Tags: Tags}' --output table
    else
        echo "No active resources of type ${resource_type} found."
    fi
    echo
done
