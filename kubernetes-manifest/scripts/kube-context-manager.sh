#!/bin/bash

# Function to extract context names
get_contexts() {
    kubectl config get-contexts -o name
}

# Function to select context
select_context() {
    contexts=$(get_contexts)
    array=()
    i=0

    # Populate the array with the contexts
    for context in ${contexts}
    do
        array[i]=${context}
        i=$((i+1))
    done

    # Display the context options
    for j in "${!array[@]}"
    do
        printf "%s - %s\n" "$j" "${array[j]}"
    done

    # Ask for user input
    read -p "Enter the number for the context you want to select: " number

    # Check if the input is a valid number
    if [[ "$number" =~ ^[0-9]+$ ]] && [ "$number" -lt "${#array[@]}" ]
    then
        echo "You selected: ${array[number]}"
        # Set the selected context
        kubectl config use-context "${array[number]}"
        # Verify the current context
        kubectl cluster-info
    else
        echo "Invalid selection. Please run the script again."
        exit 1
    fi
}

# Call the select_context function
select_context
