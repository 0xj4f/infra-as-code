 #!/bin/bash

echo "Make sure to be in root repo"

 rg="demo-dotnet6-functionapp"
 location="northeurope"
 function_app_name="demo-dotnet6-functionapp"
 storage_account_name="demodotnet6functionappstorage"
 app_service_plan_name="demo-dotnet6-asp"

echo "[+] Zipping Function App"
zip -r myfunctionapp.zip .

 az group create \
   --name $rg \
   --location $location

 az storage account create \
   --name $storage_account_name \
   --location $location \
   --resource-group $rg \
   --sku Standard_LRS

 az appservice plan create \
   --name $app_service_plan_name \
   --resource-group $rg \
   --location $location \
   --sku B1 \
   --is-linux

 az functionapp create \
   --resource-group $rg \
   --plan $app_service_plan_name \
   --name $function_app_name \
   --storage-account $storage_account_name \
   --functions-version 4 \
   --runtime "dotnet-isolated" \
   --runtime-version 6.0

 az functionapp deployment source config-zip \
   --resource-group $rg \
   --name $function_app_name \
   --src functionapp.zip

