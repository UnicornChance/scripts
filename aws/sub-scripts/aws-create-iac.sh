#!/bin/bash

### Create IAC
echo "Create IAC"
echo ""
uds run -f tasks/iac.yaml create-iac --no-progress
echo "Completed Create IAC"
echo ""