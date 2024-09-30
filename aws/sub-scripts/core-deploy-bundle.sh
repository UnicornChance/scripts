#!/bin/bash

### Once cluster is ready and IAC is deployed, deploy core bundle
echo "Deploy Core Bundle"
echo ""
export UDS_CONFIG=.github/bundles/uds-config.yaml
uds deploy .github/bundles/uds-bundle-uds-core-eks-nightly-*.tar.zst --confirm
echo "Completed Deploy Core Bundle"
echo ""