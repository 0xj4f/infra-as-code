#!/bin/bash

az account set --subscription "<subscription_id>"

resource_group="rg-demo-poc"
location="westus2" 
server_name="demopoc1"
database_name="demo.poc"
admin_user="sqladmin"
admin_password="s3cur3_th1s_sh1t"

az group create --name $resource_group \
                --location $location

az sql server create --name $server_name \
                     --resource-group $resource_group \
                     --location $location \
                     --admin-user $admin_user \
                     --admin-password $admin_password

az sql db create --resource-group $resource_group \
                 --server $server_name \
                 --name $database_name \
                 --service-objective S0

az sql server firewall-rule create --resource-group $resource_group \
                                   --server $server_name \
                                   --name AllowAllWindowsAzureIps \
                                   --start-ip-address 0.0.0.0 \
                                   --end-ip-address 0.0.0.0

echo "SQL server and database created successfully"
