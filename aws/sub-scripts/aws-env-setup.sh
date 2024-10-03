#!/bin/bash

SCRIPT_DIR="$1"

source "$SCRIPT_DIR/config.env"

### Setup AWS and UDS Env variables
echo -e "\tSetting up AWS and UDS Environment variables.\n"

export AWS_REGION="$AWS_REGION"
export UDS_REGION="$UDS_REGION"
export SHA="$SHA"
export UDS_PERMISSIONS_BOUNDARY_ARN="arn:aws:iam::835706769834:policy/uds_dev_base_policy"
export UDS_PERMISSIONS_BOUNDARY_NAME="uds_dev_base_policy"
export UDS_STATE_BUCKET_NAME="uds-dev-tfstate-west-2"
export UDS_STATE_DYNAMODB_TABLE_NAME="uds-dev-tf-state-lock-dynamodb"
export UDS_CLUSTER_NAME="$CLUSTER_NAME"
export UDS_STATE_KEY="$UDS_STATE_KEY"
export TF_VAR_region="${UDS_REGION}"
export TF_VAR_name="$CLUSTER_NAME"
export TF_VAR_use_permissions_boundary=true
export TF_VAR_permissions_boundary_name="${UDS_PERMISSIONS_BOUNDARY_NAME}"