#!/bin/bash

# Exit immediately if any command exits with a non-zero status
set -e

SCRIPT_DIR="$1"

source "$SCRIPT_DIR/config.env"

echo -e "\tRemove IAC deployment.\n"

cd $UDS_CORE_PATH

# Run the uds destroy-iac command and check for errors
if ! uds run -f "tasks/iac.yaml" destroy-iac --no-progress; then
    echo -e "\tERROR: Failed to remove IAC deployment. Exiting.\n"
    exit 1
fi

echo -e "\tCompleted removal of IAC deployment.\n"

cd $SCRIPT_DIR