#!/bin/bash

resource_group="jaf-prod-rg-demoapp"
location="northeurope"

nsg_name="jaf-prod-nsg-demoapp"
vnet_name="jaf-prod-vnet-demoapp"
subnet_name="jaf-prod-subnet-demoapp"
public_ip_name="jaf-prod-pubip-demoapp"

vm_name="jaf-prod-vm-demoapp-ne-001"
vm_admin_user='jafadmin'
vm_os=Ubuntu2204
vm_os_disk_size=50
vm_size=Standard_B2s
ssh_key_path="$HOME/.ssh/id_rsa_jaf_vm"



set -x
if [ ! -f "$ssh_key_path" ]; then
    echo "File '$ssh_key_path' does not exist."
    echo "[+] Creating SSH Keys"
    ssh-keygen -t rsa -b 4096 -C "$vm_admin_user" -f $ssh_key_path -N ""
fi

# Create Resource Group
az group create --name $resource_group \
                --location $location

# Create Network Security Group
az network nsg create --resource-group $resource_group \
                      --name $nsg_name

# Create NSG rules to allow traffic on port 22, 80, 443, 5000 and 5500
for port in 22 80 443
do
    az network nsg rule create --resource-group $resource_group \
                               --nsg-name $nsg_name \
                               --name allow-port-$port \
                               --protocol tcp \
                               --priority $(($port+1000)) \
                               --destination-port-range $port
done

# Create VNet
az network vnet create --resource-group $resource_group \
                       --name $vnet_name \
                       --address-prefix 10.0.0.0/16 \
                       --subnet-name $subnet_name \
                       --subnet-prefix 10.0.0.0/24

# Create Public IP
az network public-ip create --resource-group $resource_group \
                            --name $public_ip_name \
                            --sku Standard \
                            --version IPv4

# Create VM
az vm create --resource-group $resource_group \
             --name $vm_name \
             --image $vm_os \
             --admin-username $vm_admin_user \
             --ssh-key-value $ssh_key_path.pub \
             --public-ip-address $public_ip_name \
             --nsg $nsg_name \
             --vnet-name $vnet_name \
             --subnet $subnet_name \
             --size $vm_size  \
             --os-disk-size-gb $vm_os_disk_size
