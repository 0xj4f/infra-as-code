#!/bin/bash

# Function to process each app and check secret expiry
process_app() {
    appId=$1
    displayName=$2

    secrets=$(az ad app credential list --id "$appId" --query '[].{endDate: endDateTime}' --output json)
    firstSecret=$(echo "$secrets" | jq -r '.[] | .endDate' | sort | head -n 1)

    if [[ -n "$firstSecret" ]]; then
        formattedExpiryDate=$(date -d "$firstSecret" +%Y-%m-%d)
        days_until_expiry $formattedExpiryDate
    fi
}

# Function to calculate days until expiry
days_until_expiry() {
    formattedExpiryDate=$1
    daysUntilExpiry=$(( ($(date -d "$formattedExpiryDate" +%s) - $(date -d "$currentDate" +%s) ) / 86400 ))

    if [[ $daysUntilExpiry -lt 30 && $daysUntilExpiry -ge 0 ]]; then
        echo "App Name: $displayName"
        echo "Secret Expiry Date: $formattedExpiryDate"
        echo "Days Until Expiry Date: $daysUntilExpiry"
        echo ""
        ((expiryImminentCount++))
    fi
}

# Main script starts here
# Get a list of Azure AD Apps
apps=$(az ad app list --query '[].{appId: appId, displayName: displayName}' --output json)

currentDate=$(date +%Y-%m-%d)
expiryImminentCount=0

# Convert JSON to lines and process each app
echo "$apps" | jq -r '.[] | "\(.appId) \(.displayName)"' | while IFS=' ' read -r appId displayName; do
    process_app "$appId" "$displayName"
done

# Final report
if [[ $expiryImminentCount -eq 0 ]]; then
    echo "There are no AD Apps that currently have less than 30 days until their Secrets expire."
else
    echo "Total apps with imminent secret expiry: $expiryImminentCount"
fi
