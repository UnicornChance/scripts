#!/bin/bash



export KEYCLOAK_SERVER="https://keycloak.admin.uds.dev"
export ADMIN_USERNAME="admin"
export ADMIN_PASSWORD="admin"

# Get the access token
export ACCESS_TOKEN=$(curl -X POST "https://keycloak.admin.uds.dev/realms/master/protocol/openid-connect/token" \
     -H "Content-Type: application/x-www-form-urlencoded" \
     -d "client_id=admin-cli" \
     -d "username=admin" \
     -d "password=admin" \
     -d 'grant_type=password' | jq -r '.access_token')

curl -s -X GET "https://keycloak.admin.uds.dev/admin/realms/uds/clients?clientId=saml-test-client" \
    -H "Authorization: Bearer $ACCESS_TOKEN" \
    -H "Content-Type: application/json" | jq '.[0] | {clientId, enabled, protocol, redirectUris}'
