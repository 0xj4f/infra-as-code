#!/bin/bash

datetime=$(date '+%Y-%m-%d-%H-%M')
mkdir -p $datetime

# Fetch all resource groups in the current Azure subscription
resource_groups=$(az group list --query "[].name" -o tsv)
for resource_group_name in $resource_groups
do
    echo "Exporting ARM template for $resource_group_name..."
    az group export --name $resource_group_name --output json > ./$datetime/$resource_group_name.json
done

echo "Exporting finished. Templates can be found in the ./$datetime/ directory."
