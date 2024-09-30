#!/bin/bash

### Create AWS EKS Cluster
echo "Create AWS EKS Cluster.."
echo "Speed up iteration by running core-iac-build.sh script in another terminal.."
echo ""
uds run -f tasks/iac.yaml create-cluster --no-progress
echo "Completed AWS EKS Cluster creation"
echo ""