#!/bin/bash

### Build / Create Core package
echo "Create Core Package"
echo ""
ZARF_ARCHITECTURE=amd64 uds run -f tasks/create.yaml standard-package --no-progress --set FLAVOR=upstream
echo "Completed Core Package Creation"
echo ""