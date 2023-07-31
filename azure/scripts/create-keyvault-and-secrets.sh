#!/bin/bash

# Assign variables
resource_group="demo_rg"
location="northeurope" # Replace with your preferred location
keyvault_name="demoprojectkeyvault" # only alpha numeric
secret_name="demo_secret"
secret_value="demo_value"

# Create Resource Group
az group create \
    --name $resource_group \
    --location $location

# Create Key Vault
az keyvault create \
    --name $keyvault_name \
    --resource-group $resource_group \
    --location $location

# Set Secret in Key Vault
az keyvault secret set \
    --vault-name $keyvault_name \
    --name $secret_name \
    --value $secret_value

echo "Created Resource Group: $resource_group"
echo "Created Key Vault: $keyvault_name"
#echo "Created Secret: $secret_name"

vault_uri=$(az keyvault show \
               --name $keyvault_name \
               --resource-group $resource_group \
               --query properties.vaultUri \
               --output tsv)

echo "Key Vault URI: $vault_uri"

