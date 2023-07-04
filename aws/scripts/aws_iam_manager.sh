#!/bin/bash

# Load the yq parser (needs to be installed before running the script).
# You can install it with "sudo snap install yq"

YAML_FILE="projects.yaml"

# Get the number of projects
project_count=$(yq e '.projects | length' $YAML_FILE)

echo "Choose the project to log in:"
for ((i=0;i<$project_count;i++)); do
    # Print project names
    project_name=$(yq e ".projects[$i].name" $YAML_FILE)
    echo "$(($i+1)). $project_name"
done

read -p "Enter the number of the project you want to log in to: " project_num

# Subtract one because arrays are 0-indexed
project_num=$(($project_num-1))

# Get project data
access_key=$(yq e ".projects[$project_num].credentials.access_key" $YAML_FILE)
secret_key=$(yq e ".projects[$project_num].credentials.secret_key" $YAML_FILE)
region=$(yq e ".projects[$project_num].credentials.region" $YAML_FILE)

# AWS Configure login
aws configure set aws_access_key_id $access_key
aws configure set aws_secret_access_key $secret_key
aws configure set region $region

# Verify your account
aws sts get-caller-identity


