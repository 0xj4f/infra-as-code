# Azure 
> infra as code of Azure

- az cli
- powershell
- ARM templates
- BICEPS

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
