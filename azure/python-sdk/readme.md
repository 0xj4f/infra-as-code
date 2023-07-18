# Azure Python SDK Authentication

## Auth

### ManagedIdentity
```py
from azure.identity import ManagedIdentityCredential

credential = ManagedIdentityCredential()

# Can also specify a client ID of a user-assigned managed identity
credential = ManagedIdentityCredential(
    client_id="<client_id>",
)
```

### DefaultCredentials

```py
# other way of authentication
from azure.identity.aio import DefaultAzureCredential
from azure.keyvault.secrets.aio import SecretClient

default_credential = DefaultAzureCredential()
client = SecretClient("https://my-vault.vault.azure.net", default_credential)

```
> https://github.com/Azure/azure-sdk-for-python/blob/main/sdk/identity/azure-identity/README.md#defaultazurecredential

```
Environment - DefaultAzureCredential will read account information specified via environment variables and use it to authenticate.
Workload Identity - If the application is deployed to Azure Kubernetes Service with Managed Identity enabled, DefaultAzureCredential will authenticate with it.
Managed Identity - If the application is deployed to an Azure host with Managed Identity enabled, DefaultAzureCredential will authenticate with it.
Azure CLI - If a user has signed in via the Azure CLI az login command, DefaultAzureCredential will authenticate as that user.
Azure PowerShell - If a user has signed in via Azure PowerShell's Connect-AzAccount command, DefaultAzureCredential will authenticate as that user.
Azure Developer CLI - If the developer has authenticated via the Azure Developer CLI azd auth login command, the DefaultAzureCredential will authenticate with that account.
Interactive browser - If enabled, DefaultAzureCredential will interactively authenticate a user via the default browser. This credential type is disabled by default.
```

### Service Principals

```
from azure.keyvault.secrets import SecretClient
from azure.identity import ClientSecretCredential

credential = ClientSecretCredential(
            tenant_id='xxxxx',
            client_id='xxxxx',
            client_secret='xxxxxx'
        )


client = SecretClient(vault_url=VAULT_URL, credential=credential)
```


## References

- Key Vault - https://github.com/Azure/azure-sdk-for-python/blob/main/sdk/keyvault/azure-keyvault-keys/samples/list_operations.py
