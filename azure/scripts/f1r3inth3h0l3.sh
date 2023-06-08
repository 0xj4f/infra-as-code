#!/bin/bash 


echo "[!] Nuking Azure!" 
echo '

                                                -----
                                              /      \
                                              )      |
       :================:                      "    )/
      /||              ||                      )_ /*
     / ||    System    ||                          *
    |  ||     Down     ||                   (=====~*~======)
     \ || Please wait  ||                  0      \ /       0
       ==================                //   (====*====)   ||
........... /      \.............       //         *         ||
:\        ############            \    ||    (=====*======)  ||
: ---------------------------------     V          *          V
: |  *   |__________|| ::::::::::  |    o   (======*=======) o
\ |      |          ||   .......   |    \         *         ||
  --------------------------------- 8   ||   (=====*======)  //
                                     8   V         *         V
  --------------------------------- 8   =|=;  (==/ * \==)   =|=
  \   ###########################  \   / ! \     _ * __    / |    
   \  +++++++++++++++++++++++++++   \  ! !  !  (__/ \__)  !  !  !
    \ ++++++++++++++++++++++++++++   \        0 \ \V/ / 0
     \________________________________\     ()   \o o/   ()
      *********************************     ()           ()
'




# Variables
subscription="xxxxxxxxxxxxxxxxxxxxxxxxx"
az account set --subscription $subscription
resource_groups=$(az group list --query "[].name" -o tsv)

for rg in $resource_groups
do
  echo "Deleting resource group $rg..."
  az group delete --name $rg --yes --no-wait
done

echo "All resource groups in the subscription $subscription are being deleted..."

