#!/bin/bash

echo "Remove UDS Core package"
echo ""
uds remove .github/bundles/uds-bundle-uds-core-eks-*.tar.zst --confirm
echo "Completed removal of UDS Core Package"
echo ""