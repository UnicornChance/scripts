#!/bin/bash

# Check if argument is provided
if [ $# -ne 1 ]; then
    echo ""
    echo "One argument is required: "
    echo "  Path to uds-identity-config repo"
    echo "  Execute the command like so: $0 <path_to_directory>"
    echo ""
    exit 1
fi

# clean up existing k3d cluster, docker container, and docker network
k3d cluster delete uds && docker stop external && docker rm external

# setup uds-core-identity-config keycloak k3d-cluster
cd $1
uds run uds-core-integration-tests

# setup keycloak docker container for broker
docker run -d --net=host --name external -e KEYCLOAK_ADMIN=admin -e KEYCLOAK_ADMIN_PASSWORD=admin quay.io/keycloak/keycloak:24.0.3 start-dev

# Internal Keycloak Configuration
echo ""
echo "Keycloak Configuration Click OPS"
echo ""
echo "UDS-Core Keycloak Configuration"
echo "1. Run the command 'zarf connect keycloak' to configure the admin user"
echo "2. Create realm 'internal'"
echo "3. Create client 'kc-broker'"
echo "   1. 'Client Authentication' -> toggled on"
echo "   2. 'Valid redirect URIs' -> 'http://127.0.0.1:8080/*' (or wherever the external Keycloak is deployed)"
echo "   3. Save"
echo "4. Save client 'kc-broker' credential and client id for external Keycloak IDP configuration"
echo "5. Create test user with credentials for testing against"

# External Keycloak Configuration
echo ""
echo "Docker container Keycloak Configuration"
echo "1. Create realm 'external'"
echo "2. Create Identity Provider - Keycloak OpenID Connect"
echo "   1. 'Use discovery endpoint' - toggle off"
echo "   2. 'Authorization URL' - https://sso.uds.dev/realms/internal/protocol/openid-connect/auth"
echo "   3. 'Token URL' - https://sso.uds.dev/realms/internal/protocol/openid-connect/token"
echo "   4. 'Client ID' - client id from internal Keycloak = 'kc-broker'"
echo "   5. 'Client Secret' - client secret from internal Keycloak credentials"

echo ""
echo "Navigate to external keycloak account console for testing"
echo "http://127.0.0.1:8080/realms/external/account"
echo ""