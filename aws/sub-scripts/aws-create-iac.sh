#!/bin/bash

# Exit immediately if any command exits with a non-zero status
set -e

SCRIPT_DIR="$1"

source "$SCRIPT_DIR/config.env"

### Create IAC
echo -e "\tCreate IAC.\n"

cd $UDS_CORE_PATH

# Run the uds create-iac command and check for errors
if ! uds run -f "tasks/iac.yaml" create-iac --no-progress; then
    echo -e "\tERROR: Failed to create IAC. Exiting.\n"
    exit 1
fi

echo -e "\tCompleted Create IAC.\n"

cd $SCRIPT_DIR