#!/bin/bash

# Exit immediately if any command exits with a non-zero status
set -e

SCRIPT_DIR="$1"

source "$SCRIPT_DIR/config.env"

echo -e "\tRemove AWS Cluster.\n"

cd $UDS_CORE_PATH

# Run the uds destroy-cluster command and check for errors
if ! uds run -f "tasks/iac.yaml" destroy-cluster --no-progress; then
    echo -e "\tERROR: Failed to remove AWS Cluster. Exiting.\n"
    exit 1
fi

echo -e "\tCompleted removal of AWS Cluster.\n"

cd $SCRIPT_DIR