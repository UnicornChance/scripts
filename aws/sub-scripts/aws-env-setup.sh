#!/bin/bash

### Check user is AWS Authenticated
echo "Checking authenticated to AWS"
echo ""
if aws sts get-caller-identity >/dev/null 2>&1; then
    echo "Authenticated to AWS."
    echo ""
else
    echo "You need to authenticate to AWS before this script will work"
    echo ""
    exit 1
fi