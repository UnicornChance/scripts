# Keycloak to Keycloak IDP
How to configure a Keycloak to connect to another Keycloak as broker / IDP.

## Using the script
```bash
    # clone repo or just copy the script
    git clone git@github.com:UnicornChance/scripts.git

    cd scripts/keycloak

    # run script
    ./keycloak-to-keycloak.sh

    # follow output in terminal or check back to this doc
```

## Steps taken
### Container Setup
```bash
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

    # get the internal container ip for setting the external idp configuration
    docker network inspect kcNetwork | jq -r '.[0].Containers | to_entries[] | select(.value.Name == "internal") | .value.IPv4Address | split("/")[0]'
```

---

## Click Ops Configuration
### Internal Keycloak Configuration

1. Create realm `internal`

2. Create client `kc-broker`

   1. `Client Authentication` -> toggled o
   
   2. `Valid redirect URIs` -> `http://127.0.0.1:8081/*` ( or wherever the external keycloak is deployed )

   3. Save

3. Save client `kc-broker` credential and client id for external keycloak idp configuration

4. create test user with credentials for testing against


### External Keycloak Configuration
1. Create realm `external`

2. Create Identity Provider - keycloak OpenID Connect
   1. `Use discovery endpoint` - toggle off

   2. `Authorization URL` - `http://172.19.0.2:8080/realms/internal/protocol/openid-connect/auth`
      1. ip output from earlier for internal keycloak container + internal port + auth endpoint

   3. `Token URL` - `http://172.19.0.2:8080/realms/internal/protocol/openid-connect/token`
      1. same as Authorization URL with token endpoint

   4. `Client ID` - client id from internal keycloak = `kc-broker`

   5. `Client Secret` - client secret from internal keycloak credentials
