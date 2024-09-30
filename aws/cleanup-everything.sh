#!/bin/bash

echo ""
echo "Clean remove UDS Core, IAC, and AWS Cluster"
echo ""

./sub-scripts/core-remove-package.sh

./sub-scripts/aws-remove-iac.sh

./sub-scripts/aws-remove-cluster.sh