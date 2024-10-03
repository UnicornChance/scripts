#!/bin/bash

# Exit immediately if any sub-script fails
set -e

# Get the directory where this script is located
CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "\nSetup / Create / Deploy everything.\n"

# Source aws-env-setup.sh to ensure environment variables are set in the current session
source "$CURRENT_DIR/sub-scripts/aws-env-setup.sh" "$CURRENT_DIR"

# Run aws-setup-eks.sh in its own background thread
"$CURRENT_DIR/sub-scripts/aws-setup-eks.sh" "$CURRENT_DIR" &

# Capture the process ID of this thread to wait on later
EKS_PID=$!

# Run core-create-package.sh, core-create-bundle.sh in parallel
(
    "$CURRENT_DIR/sub-scripts/core-create-package.sh" "$CURRENT_DIR"
    "$CURRENT_DIR/sub-scripts/core-create-bundle.sh" "$CURRENT_DIR"
) &

# Capture the process ID of the parallel tasks
PARALLEL_PID=$!

# Wait for both threads to complete
wait $EKS_PID
wait $PARALLEL_PID

# Run the final scripts after both threads are complete
"$CURRENT_DIR/sub-scripts/aws-create-iac.sh" "$CURRENT_DIR"
"$CURRENT_DIR/sub-scripts/core-deploy-bundle.sh" "$CURRENT_DIR"

echo -e "\n\nUse eksctl 'utils write-kubeconfig --cluster $UDS_CLUSTER_NAME --region $AWS_REGION' to configure your local kube config to connect to the AWS cluster\n\n"
