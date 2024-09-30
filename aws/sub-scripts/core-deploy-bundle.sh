#!/bin/bash

### Once cluster is ready and IAC is deployed, deploy core bundle
echo "Deploy Core Bundle"
echo ""
uds deploy .github/bundles/uds-bundle-uds-core-eks-nightly-*.tar.zst --confirm --set UDS_CONFIG=.github/bundles/uds-config.yaml
echo "Completed Deploy Core Bundle"
echo ""