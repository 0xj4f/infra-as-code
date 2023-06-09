#!/bin/bash

resource_groups=$(az group list --query '[].name' -o tsv)

for rg in $resource_groups
do  
  echo "[+] RG: $rg"
  echo "[+]======================================================================="

  printf "%-45s %-60s %-40s\n" "Name" "Type" "Location"
  az resource list -g $rg --query '[].{Name:name, Type:type, Location:location}' -o tsv | while IFS=$'\t' read -r name type location
  do
    printf "%-45s %-60s %-40s\n" "$name" "$type" "$location"
  done
  echo "[+]----------------------------------------------------------------------"
  echo; echo;
done

