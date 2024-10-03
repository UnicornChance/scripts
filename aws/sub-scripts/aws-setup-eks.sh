#!/bin/bash

# Exit immediately if any command exits with a non-zero status
set -e

SCRIPT_DIR="$1"

source "$SCRIPT_DIR/config.env"

### Create AWS EKS Cluster
echo -e "\tCreate AWS EKS Cluster..\n"

cd $UDS_CORE_PATH

# Run the uds command and capture its exit code
if ! uds run -f "tasks/iac.yaml" create-cluster --no-progress; then
    echo -e "\t\nFailed to create AWS EKS Cluster. Exiting with code 1.\n"
    exit 1
fi

echo -e "\tCompleted AWS EKS Cluster creation.\n"

cd $SCRIPT_DIR