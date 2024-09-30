#!/bin/bash

echo ""
echo "Rebuild Core and IAC Deployment"
echo ""

./sub-scripts/change-directory.sh

./sub-scripts/core-create-package.sh

./sub-scripts/core-create-bundle.sh

./sub-scripts/aws-create-iac.sh

./sub-scripts/core-deploy-bundle.sh