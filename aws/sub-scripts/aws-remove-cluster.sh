#!/bin/bash

echo "Remove AWS Cluster"
echo ""
uds run -f tasks/iac.yaml destroy-cluster --no-progress
echo "Completed removal of AWS Cluster"
echo ""