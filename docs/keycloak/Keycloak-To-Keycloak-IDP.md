# Keycloak to Keycloak IDP
How to configure a Keycloak to connect to another Keycloak as broker / IDP.

Examples of two keycloak docker containers running and connecting together. Also using uds-core as an IDP and a keycloak docker container as a broker.

## Using two Keycloak Docker Containers
### Script
   ```bash
      # clone repo or just copy the script
      git clone git@github.com:UnicornChance/scripts.git

      cd scripts/keycloak

      # run script
      ./docker-idp-docker-broker.sh

      # follow output in terminal or check back to this doc
   ```

### Manual Steps
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

### Click Ops Internal Keycloak Configuration

   1. Create realm `internal`

   2. Create client `kc-broker`

      1. `Client Authentication` -> toggled on
      
      2. `Valid redirect URIs` -> `http://127.0.0.1:8081/*` ( or wherever the external keycloak is deployed )

      3. Save

   3. Save client `kc-broker` credential and client id for external keycloak idp configuration

   4. create test user with credentials for testing against


### Click Ops External Keycloak Configuration
   1. Create realm `external`

   2. Create Identity Provider - keycloak OpenID Connect
      1. `Use discovery endpoint` - toggle off

      2. `Authorization URL` - `http://172.19.0.2:8080/realms/internal/protocol/openid-connect/auth`
         1. ip output from earlier for internal keycloak container + internal port + auth endpoint

      3. `Token URL` - `http://172.19.0.2:8080/realms/internal/protocol/openid-connect/token`
         1. same as Authorization URL with token endpoint

      4. `Client ID` - client id from internal keycloak = `kc-broker`

      5. `Client Secret` - client secret from internal keycloak credentials

---

## Using UDS-Core Keycloak as IDP and Keycloak docker container as broker
### Script
   ```bash
      # clone repo or just copy the script
      git clone git@github.com:UnicornChance/scripts.git

      cd scripts/keycloak

      # run script
      ./core-idp-docker-broker.sh

      # follow output in terminal or check back to this doc
   ```

### Steps Taken
   ```bash

      # in uds-identty-config, deploy uds-core with keycloak
      uds run uds-core-integration-tests

      # in another terminal
      # deploy keycloak docker container
      # important to note the --net-host to set this container to run on host
      docker run -d --net=host --name external -e KEYCLOAK_ADMIN=admin -e KEYCLOAK_ADMIN_PASSWORD=admin quay.io/keycloak/keycloak:24.0.3 start-dev

      # tail docker logs for keycloak container
      docker logs -f external
   ```

### Click Ops Internal Keycloak ( uds-core cluster )
   1. Run `zarf connect keycloak` to configure the admin user

   2. Access UDS-Core keycloak at `keycloak.admin.uds.dev`

   3. Create realm `internal`

   4. Create client `kc-broker`

      1. `Client Authentication` -> toggled on
      
      2. `Valid redirect URIs` -> `http://127.0.0.1:8080/*` ( or wherever the external keycloak is deployed )

      3. Save

   5. Save client `kc-broker` credential and client id for external keycloak idp configuration

   6. create test user with credentials for testing against

### Click Ops External Keycloak ( docker container )
   1. Access Keycloak docker at `127.0.0.1:8080`

   2. Create realm `external`

   3. Create Identity Provider - keycloak OpenID Connect
      1. `Use discovery endpoint` - toggle off

      2. `Authorization URL` - `https://sso.uds.dev/realms/internal/protocol/openid-connect/auth`
         1. ip output from earlier for internal keycloak container + internal port + auth endpoint

      3. `Token URL` - `https://sso.uds.dev/realms/internal/protocol/openid-connect/token`
         1. same as Authorization URL with token endpoint

      4. `Client ID` - client id from internal keycloak = `kc-broker`

      5. `Client Secret` - client secret from internal keycloak credentials


#### Trouble shooting commands
   ```bash
      # exec into the docker keycloak container as root 
      docker exec -u root -it external sh

      # view docker container logs
      docker logs -f external

      # change modify docker keycloak container /etc/hosts file when no editing tools available
      echo "172.16.0.3 sso.uds.dev" >> /etc/hosts

      # remove the line that was added in previous command
      grep -v '172.16.0.3 sso.uds.dev' /etc/hosts > /etc/hosts.tmp && cp /etc/hosts.tmp /etc/hosts && rm /etc/hosts.tmp
   ```