#!/bin/bash

### Check user is AWS Authenticated
echo -e "\tChecking authenticated to AWS\n"
if aws sts get-caller-identity >/dev/null 2>&1; then
    echo -e "\tAuthenticated to AWS.\n"
else
    echo -e "\tYou need to authenticate to AWS before this script will work.\n"
    echo -e "\tEasiest option is to copy AWS Access Keys into terminal, then re-run script.\n"
    exit 1
fi
