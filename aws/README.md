# AWS Development Scripts

## Quick Start
Update the config.env with your machine and cluster variables. Run the `setup-everything.sh`

## Main Scripts
| File Name | Description |
| - | - |
| `setup-everything.sh` | Sets up the AWS environment and UDS Core by running all necessary subscripts. It prepares and deploys the EKS cluster, builds core packages and bundles, creates infrastructure, and deploys everything in sequence, with some parallelization to speed up the process. |
| `rebuild-core-iac.sh` | Rebuilds the UDS Core package, bundle, and infrastructure. Runs core package creation, bundle creation, and IAC creation in parallel to speed up the rebuild process, followed by deploying the updated core bundle to the EKS cluster. |
| `remove-core-iac.sh` | Removes the UDS Core package and associated infrastructure (IAC) to clean up the environment. It uses subscripts to remove all resources related to UDS Core and IAC. **Does not remove the cluster from AWS.** |
| `cleanup-everything.sh` | Performs a complete clean-up of the environment by removing the UDS Core package, IAC deployment, and AWS EKS cluster. Executes subscripts in sequence to ensure that all resources are properly and cleanly removed. |


## Sub Scripts
| File Name                 | Description                                                                                |
|---------------------------|--------------------------------------------------------------------------------------------|
| `aws-env-setup.sh`        | Sets up AWS and UDS environment variables from `config.env`.                               |
| `aws-auth-check.sh`       | Verifies that the user is authenticated to AWS before proceeding with other operations.    |
| `aws-setup-eks.sh`        | Sets up the AWS EKS cluster, running in parallel with package and bundle creation scripts. |
| `core-create-package.sh`  | Builds and creates the UDS Core package by running tasks defined in `iac.yaml`.            |
| `core-create-bundle.sh`   | Builds and creates the UDS Core CI bundle, generating deployment artifacts.                |
| `aws-create-iac.sh`       | Creates infrastructure as code (IAC) resources for the environment setup.                  |
| `core-deploy-bundle.sh`   | Deploys the UDS Core bundle to the EKS cluster once all other scripts have completed.      |
| `core-remove-package.sh`	| Removes the UDS Core package artifacts from the environment. Uses uds remove to cleanly remove the core bundle. |
| `aws-remove-iac.sh`	    | Removes the infrastructure as code (IAC) components from AWS. Uses uds to destroy the IAC components defined in iac.yaml. |
| `aws-remove-cluster.sh`	| Destroys the AWS EKS cluster, cleaning up the cluster resources to return the environment to its pre-setup state.


## Useful commands

Connect to cluster with kubectl:
```bash
eksctl utils write-kubeconfig --cluster <cluster-name> --region <region-name>
```

Decode secret from cluster:
```bash
kubectl get secret <secret-name> -n <secret-namespace> -o json | jq -r '.data | map_values(@base64d)'
```

## Common Errors
Does depend on local uds-core repo, so make sure you're deploying the uds-core you think you are.
