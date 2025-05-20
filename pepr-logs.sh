#!/bin/bash

# Set the namespace
NAMESPACE="pepr-system"

# Get the list of pod names
PODS=$(kubectl get pods -n $NAMESPACE -o jsonpath='{.items[*].metadata.name}')

# Check if any pods were found
if [ -z "$PODS" ]; then
    echo "No pods found in the namespace $NAMESPACE."
    exit 1
fi

# Loop through each pod name and fetch the logs if it doesn't include 'watcher'
for POD in $PODS; do
    if [[ $POD == *"watcher"* ]]; then
        echo "Skipping $POD as it includes 'watcher'"
        continue
    fi
    echo "Fetching logs for $POD"
    kubectl logs $POD -n $NAMESPACE > "${POD}.json"
    echo "Logs saved to ${POD}.json"
done

echo "Logs fetching process completed."

