#!/bin/bash

# Get the directory where this script is located
CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source aws-env-setup.sh to ensure environment variables are set in the current session
source "$CURRENT_DIR/sub-scripts/aws-env-setup.sh" "$CURRENT_DIR"

echo -e "\nClean remove UDS Core, IAC, and AWS Cluster.\n"

"$CURRENT_DIR/sub-scripts/core-remove-package.sh" "$CURRENT_DIR"
"$CURRENT_DIR/sub-scripts/aws-remove-iac.sh" "$CURRENT_DIR"
"$CURRENT_DIR/sub-scripts/aws-remove-cluster.sh" "$CURRENT_DIR"