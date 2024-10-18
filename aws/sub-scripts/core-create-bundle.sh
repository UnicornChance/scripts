#!/bin/bash

# Exit immediately if any command exits with a non-zero status
set -e

SCRIPT_DIR="$1"

source "$SCRIPT_DIR/config.env"

### Build/Create Core Bundle
echo -e "\tCreate Core CI Bundle.\n"

# Change to the directory where the core bundle should be created
cd $UDS_CORE_PATH

# Run the uds create command and check for errors
if ! uds create ".github/bundles/eks" --confirm; then
    echo -e "\tERROR: Failed to create Core CI Bundle. Exiting.\n"
    exit 1
fi

echo -e "\tCompleted Core CI Bundle Creation.\n"

cd $SCRIPT_DIR