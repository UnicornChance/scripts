#!/bin/bash

# Exit immediately if any command exits with a non-zero status
set -e

SCRIPT_DIR="$1"

source "$SCRIPT_DIR/config.env"

echo -e "\tRemove UDS Core package.\n"

cd $UDS_CORE_PATH

# Find the actual bundle file using wildcard expansion
BUNDLE_FILE=$(find "$UDS_CORE_PATH.github/bundles" -name 'uds-bundle-uds-core-eks-nightly-*.tar.zst')

# Run the uds remove command and check for errors
if ! uds remove "$BUNDLE_FILE" --confirm; then
    echo -e "\tERROR: Failed to remove UDS Core Package. Exiting.\n"
    exit 1
fi

echo -e "\tCompleted removal of UDS Core Package.\n"

cd $SCRIPT_DIR