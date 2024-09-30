#!/bin/bash

echo ""
echo "Clean remove UDS Core and IAC"
echo ""

./sub-scripts/change-directory.sh

./sub-scripts/core-remove-package.sh

./sub-scripts/aws-remove-iac.sh
