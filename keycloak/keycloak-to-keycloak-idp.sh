#!/bin/bash

# Notify user about the --debug flag
echo "This script can be run with the --debug flag to start Keycloak in non-detached mode."

# clean up existing docker container and network
docker stop internal && docker rm internal
docker stop external && docker rm external
docker network rm kcNetwork

# create internal and external keycloak docker containers
docker run -d -p 8080:8080 --name internal -e KEYCLOAK_ADMIN=admin -e KEYCLOAK_ADMIN_PASSWORD=admin quay.io/keycloak/keycloak:24.0.3 start-dev
docker run -d -p 8081:8080 --name external -e KEYCLOAK_ADMIN=admin -e KEYCLOAK_ADMIN_PASSWORD=admin quay.io/keycloak/keycloak:24.0.3 start-dev

# create docker network between containers
docker network create kcNetwork
docker network connect kcNetwork internal
docker network connect kcNetwork external

echo ""
docker ps

echo ""
echo "Internal Keycloak IP for configuring External Keycloak IDP: "
# get the internal container ip for setting the external idp configuration
internal_ip=$(docker network inspect kcNetwork | jq -r '.[0].Containers | to_entries[] | select(.value.Name == "internal") | .value.IPv4Address | split("/")[0]')
echo $internal_ip
echo ""

# Internal Keycloak Configuration
echo ""
echo "Keycloak Configuration Click OPS"
echo ""
echo "Internal Keycloak Configuration"
echo "1. Create realm 'internal'"
echo "2. Create client 'kc-broker'"
echo "   1. 'Client Authentication' -> toggled on"
echo "   2. 'Valid redirect URIs' -> 'http://127.0.0.1:8081/*' (or wherever the external Keycloak is deployed)"
echo "   3. Save"
echo "3. Save client 'kc-broker' credential and client id for external Keycloak IDP configuration"
echo "4. Create test user with credentials for testing against"

# External Keycloak Configuration
echo ""
echo "External Keycloak Configuration"
echo "1. Create realm 'external'"
echo "2. Create Identity Provider - Keycloak OpenID Connect"
echo "   1. 'Use discovery endpoint' - toggle off"
echo "   2. 'Authorization URL' - $internal_ip:8080/realms/internal/protocol/openid-connect/auth"
echo "   3. 'Token URL' - $internal_ip:8080/realms/internal/protocol/openid-connect/token"
echo "   4. 'Client ID' - client id from internal Keycloak = 'kc-broker'"
echo "   5. 'Client Secret' - client secret from internal Keycloak credentials"

echo ""
echo "Navigate to external keycloak account console for testing"
echo "http://127.0.0.1:8081/realms/external/account"
echo ""