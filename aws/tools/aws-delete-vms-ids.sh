#!/bin/bash

vms_tobe_deleted=(
  i-09999999999999999
  i-09999999999999999
) 

for vm_id in "${vms_tobe_deleted[@]}"; do
  vm_name=$(aws ec2 describe-instances --instance-ids $vm_id --query 'Reservations[].Instances[].Tags[?Key==`Name`].Value[]' --output text)
  
  echo "VM ID: $vm_id"
  echo "VM Name: $vm_name"
  
  # Force delete the instance
  aws ec2 terminate-instances --instance-ids $vm_id --output text
done
