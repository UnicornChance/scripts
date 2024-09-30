#!/bin/bash

echo ""
echo "Setup / Create / Deploy everything."
echo ""

./sub-scripts/change-directory.sh

./sub-scripts/aws-auth-check.sh

./sub-scripts/aws-env-setup.sh

./sub-scripts/aws-setup-eks.sh

./sub-scripts/core-create-package.sh

./sub-scripts/core-create-bundle.sh

./sub-scripts/aws-create-iac.sh

./sub-scripts/core-deploy-bundle.sh
