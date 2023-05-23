#!/bin/bash
aws ec2 describe-instances --query 'Reservations[*].Instances[*].[InstanceId,Tags[?Key==`Name`].Value|[0],InstanceType,State.Name,PublicIpAddress,VpcId,LaunchTime]' --output table
