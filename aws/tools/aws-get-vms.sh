#!/bin/bash

# simple
#aws ec2 describe-instances --query 'Reservations[*].Instances[*].[InstanceId,Tags[?Key==`Name`].Value|[0],InstanceType,State.Name,PublicIpAddress,VpcId,LaunchTime]' --output table

aws ec2 describe-instances \
    --query 'Reservations[].Instances[].{InstanceId:InstanceId, Name: Tags[?Key==`Name`]|[0].Value, State:State.Name, LaunchTime:LaunchTime, PrivateIP: PrivateIpAddress, PublicIpAddress:PublicIpAddress, Size: InstanceType, PublicDNS: PublicDnsName}' \
    --output table

