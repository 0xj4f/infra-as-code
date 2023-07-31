#!/bin/bash

"""
Tested in 
"azure-cli": "2.49.0",
"azure-cli-core": "2.49.0",
"azure-cli-telemetry": "1.0.8"
"""

resource_group="rg_demo_project"
keyvault_name="demoprojectkeyvault" # only alpha numeric

secrets=$(az keyvault secret list --vault-name $keyvault_name --query "[].name" --output tsv)

echo "List of Secrets in Key Vault $keyvault_name:"
while IFS= read -r secret_name; do
    secret_value=$(az keyvault secret show --name $secret_name --vault-name $keyvault_name --query "value" --output tsv)
    echo "[+] $secret_name: $secret_value"
done <<< "$secrets"
