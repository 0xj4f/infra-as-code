# Azure 
> infra as code of Azure

- az cli
- powershell
- ARM templates
- BICEPS
## Installations 
**CLI**
```bash
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
```


**DOCKER**

```
docker run -it mcr.microsoft.com/azure-cli

# If you want to pick up the SSH keys from your user environment, 
# use -v ${HOME}/.ssh:/root/.ssh to mount your SSH keys in the environment.
docker run -it -v ${HOME}/.ssh:/root/.ssh mcr.microsoft.com/azure-cli
```

access tokens saved in ~/.azure/accessTokens.json

## Subscriptions

Run the following command to log in to your Azure account:
```bash
az login
# this will open a tab in you browser then pick you account

az config set core.allow_broker=true
az account clear
az login
```

Once logged in, you'll see a JSON output with a list of your available subscriptions, including their names and IDs. Find the subscription ID corresponding to "Azure Subscription 1".
```json
[
  {
    "cloudName": "AzureCloud",
    "homeTenantId": "xxxxxxxxxx-xxxxxxxxxx-xxxxxxxxxx-xxxxxxxxxx-xxxxxxxxxx",
    "id": "xxxxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxx", 
    "isDefault": true,
    "managedByTenants": [],
    "name": "Azure subscription 1",
    "state": "Enabled",
    "tenantId": "xxxxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxx",
    "user": {
      "name": "example@gmail.com",
      "type": "user"
    }
  },
  {
    "cloudName": "AzureCloud",
    "homeTenantId": "xxxxxxxxxx-xxxxxxxxxx-xxxxxxxxxx-xxxxxxxxxx-xxxxxxxxxx",
    "id": "xxxxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxx",
    "isDefault": false,
    "managedByTenants": [],
    "name": "Test Subscription",
    "state": "Enabled",
    "tenantId": "xxxxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxx",
    "user": {
      "name": "example@gmail.com",
      "type": "user"
    }
  }
]
```

Set the active subscription to "Azure Subscription 1" by running the following command (replace <subscription_id> with the actual subscription ID you found in step 3):

```bash
az account set --subscription <subscription_id>
az account set --subscription xxxxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxx
```

Now, all subsequent Azure CLI commands will use "Azure Subscription 1" as the active subscription.

To verify that the correct subscription is active, you can run:

```bash
az account show
# json will validate your account
```

get all subscription
```
az account list --output table
```

## IAM 

check roles assignment list
```
# json
az role assignment list --assignee $(az account show --query user.name -o tsv)

# table 
az role assignment list --assignee $(az account show --query user.name -o tsv) --output table
```

get all users in aad 
```
# json 
az ad user list 

# table 
az ad user list --output table
```


## Service Principals

Required Permissions:
- Azure Active Directory Global Administrator
- Application administrator
- Cloud application administrator


If you've lost the secret, you will need to create a new one. 
Here's how you can do that:
```bash
name=demo-sp
az ad sp credential reset --name $name
# or
id=1231231232131
az ad sp credential reset --id $id
```
## Resource Groups

List all Resource Group
```
az group list --output table
```

Delete Resource Group
```
az group delete -n $rg
```

script that deletes all resources group
```bash
#!/bin/bash

# Get the list of resource group names
resource_groups=$(az group list --query "[].name" -o tsv)

# Loop through the resource groups and delete each one
for rg in $resource_groups; do
  echo "Deleting resource group: $rg"
  az group delete --name $rg --yes --no-wait
done

echo "All resource groups have been queued for deletion."

```

## Azure SDK or API
```
az login
az account get-access-token | tee az-access-token.json
```

## References
https://learn.microsoft.com/en-us/cli/azure/


