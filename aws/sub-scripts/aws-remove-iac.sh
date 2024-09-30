#!/bin/bash

echo "Remove IAC deployment"
echo ""
uds run -f tasks/iac.yaml destroy-iac --no-progress
echo "Completed removal of IAC deployment"
echo ""
