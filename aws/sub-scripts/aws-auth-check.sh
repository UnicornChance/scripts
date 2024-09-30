#!/bin/bash

### Setup AWS and UDS Env variables
echo "Setting up AWS and UDS Environment variables"
echo ""
export AWS_REGION=us-west-2
export UDS_REGION=us-west-2
export SHA=chancedev
export UDS_PERMISSIONS_BOUNDARY_ARN=arn:aws:iam::835706769834:policy/uds_dev_base_policy
export UDS_PERMISSIONS_BOUNDARY_NAME=uds_dev_base_policy
export UDS_STATE_BUCKET_NAME=uds-dev-tfstate-west-2
export UDS_STATE_DYNAMODB_TABLE_NAME=uds-dev-tf-state-lock-dynamodb
export UDS_CLUSTER_NAME=uds-dev-chance
export UDS_STATE_KEY=dev-chance.tfstate
export TF_VAR_region=${UDS_REGION}
export TF_VAR_name=uds-dev-chance
export TF_VAR_use_permissions_boundary=true
export TF_VAR_permissions_boundary_name=${UDS_PERMISSIONS_BOUNDARY_NAME}