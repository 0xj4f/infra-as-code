
title="[POC] DevOps Ticketing Systen"
work_type="Product Backlog Item"
description="TASK - LOREM IPSUM "
org="https://dev.azure.com/orgname"
project="ProjectName"
area_path="ProjectName\\BoardName"

set -x
az config set extension.use_dynamic_install=yes_without_prompt

az boards work-item create \
  --title "$title" \
  --type "$work_type" \
  --description "$description" \
  --org "$org" \
  --project "$project" \
  --area "$area_path" | tee new-ticket.json

id=$(cat new-ticket.json | jq '.id')
state="Committed"
az boards work-item update \
  --id $id \
  --state "$state" \
  --org "$org"




# NOTES: FOR USING IN AZURE PIPLINE
# - task: AzureCLI@2
#   inputs:
#     azureSubscription: 'KyckrProductionServiceConnection'
#     scriptType: 'bash'
#     scriptLocation: 'scriptPath'
#     scriptPath: '$(System.DefaultWorkingDirectory)/create-devops-board-work-item.sh'
#   env:
#     AZURE_DEVOPS_EXT_PAT: $(System.AccessToken) 

# Then Login
# echo $(System.AccessToken) | az devops login 
# OR
# echo $AZURE_DEVOPS_EXT_PAT | az devops login
