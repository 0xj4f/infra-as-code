#!/bin/bash

# Fetch all resource groups and store in an array
resource_groups=($(az group list --query '[].name' -o tsv))

# Loop through each resource group
for resource_group in "${resource_groups[@]}"; do
    echo "[+]================================================"
    echo "[+] Processing Resource Group: $resource_group"

    # Create a directory for the resource group
    mkdir -p "exported_templates/$resource_group"

    # Get all resources in the resource group
    resources=($(az resource list --resource-group "$resource_group" --query '[].id' -o tsv))

    # Loop through each resource and export the ARM template
    for resource_id in "${resources[@]}"; do
        # Check if the resource ID looks valid
        if [[ "$resource_id" == */providers/* ]]; then
            echo "Exporting ARM template for resource: $resource_id"

            # Extract the resource name for the file name
            resource_name=$(echo "$resource_id" | awk -F/ '{print $(NF)}')

            # Export the template and save to a file
            if az group export --resource-group "$resource_group" --resource-ids "$resource_id" > "exported_templates/$resource_group/$resource_name.json"; then
                echo "[+] Successfully exported ARM template for $resource_id"
            else
                echo -e "\e[31m[-] ERROR: Failed to export ARM template for $resource_id\e[0m"
            fi
        else
            echo -e "\e[31m[-]Skipping invalid resource ID: $resource_id\e[0m"
        fi
    done
    echo; echo;
done
