#!/bin/bash

# Exit immediately if any command exits with a non-zero status
set -e

SCRIPT_DIR="$1"

source "$SCRIPT_DIR/config.env"

### Once cluster is ready and IAC is deployed, deploy core bundle
echo -e "\tDeploy Core Bundle.\n"

cd "$UDS_CORE_PATH"

# Export UDS_CONFIG environment variable
export UDS_CONFIG="$UDS_CORE_PATH.github/bundles/eks/uds-config.yaml"

# Find the actual bundle file using wildcard expansion
BUNDLE_FILE=$(find "$UDS_CORE_PATH.github/bundles/eks" -name 'uds-bundle-uds-core-eks-nightly-*.tar.zst')

# Run the uds deploy command and check for errors
if ! uds deploy "$BUNDLE_FILE" --confirm; then
    echo -e "\tERROR: Failed to deploy Core Bundle. Exiting.\n"
    exit 1
fi

echo -e "\tCompleted Deploy Core Bundle.\n"

cd "$SCRIPT_DIR"