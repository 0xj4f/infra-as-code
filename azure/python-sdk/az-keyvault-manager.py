from azure.identity import ClientSecretCredential
from azure.keyvault.secrets import SecretClient

class KeyVaultSecretManager:
    def __init__(self, tenant_id, client_id, client_secret, vault_url):
        self.credential = ClientSecretCredential(
            tenant_id=tenant_id,
            client_id=client_id,
            client_secret=client_secret
        )
        self.client = SecretClient(vault_url=vault_url, credential=self.credential)
    
    def set_secret(self, name, value):
        self.client.set_secret(name, value)
        print(f"Secret '{name}' set.")
    
    def delete_secret(self, name):
        delete_operation = self.client.begin_delete_secret(name)
        deleted_secret = delete_operation.result()
        print(f"Secret '{name}' deleted.")
    
    def get_all_secret_names(self):
        secret_names = [secret.name for secret in self.client.list_properties_of_secrets()]
        return secret_names
    
    def print_all_secret_names_values(self):
        secret_names = self.get_all_secret_names()
        for name in secret_names:
            value = self.client.get_secret(name).value
            print(f"Secret name: {name}, Secret value: {value}")

if __name__ == '__main__':
    manager = KeyVaultSecretManager(
          tenant_id='your-tenant-id',
          client_id='your-client-id',
          client_secret='your-client-secret',
          vault_url='your-vault-url'
    )
    manager.set_secret('test-secret', 'test-value')
    manager.print_all_secret_names_values()
    manager.delete_secret('test-secret')
