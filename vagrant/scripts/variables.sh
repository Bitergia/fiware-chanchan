#!/bin/bash

# where the scripts are located
export SCRIPTS_PATH="${SCRIPTS_PATH:-/vagrant/scripts}"

# server hostname
export HOSTNAME="$(hostname -f)"

# util scripts path
export UTILS_PATH="${SCRIPTS_PATH}/util"

# define this when the IP can not be obtained from the network interface configuration
export PUBLIC_IP=""

# default interface for the public ip
export IFACE="${IFACE:-eth1}"

### IDM related variables
export IDM_HOSTNAME="idm.${HOSTNAME}"
export IDM_URL="https://${IDM_HOSTNAME}"

# default password for mysql root user
export ROOT_DBPASSWD="rootpw"

# default user, password and name for production database
export IDM_DBNAME="idmdb"
export IDM_DBUSER="idmdbuser"
export IDM_DBPASS="idmdbpass"

# user to register chanchan app on IDM
export CC_USER_NAME="Chanchan Admin"
export CC_EMAIL="chanchan@${IDM_HOSTNAME}"
export CC_PASS="ccadmin"

### Chanchan related variables
export CC_HOSTNAME="chanchan.${HOSTNAME}"
export CC_APP_SERVER_PATH="fiware-chanchan/server"
export CC_APP_CLIENT_PATH="fiware-chanchan/client"
export CC_APP_URL="http://${CC_HOSTNAME}"
export CC_APP_CALLBACK="${CC_APP_URL}/login"
export CC_OAUTH_CREDENTIALS="/tmp/appoauth.txt"

### Cygnus related variables
export CYGNUS_HOSTNAME="localhost"
export CYGNUS_USER="chanchan"
export CYGNUS_CONNECTORS_HOME="fiware-connectors"
export APACHE_FLUME_HOME="APACHE_FLUME_HOME"
export CKAN_API_KEY="44f762b2-978a-40ca-9dfc-1a8ec8855599"

### Orion related variables
export ORION_USER="chanchan"
export ORION_HOSTNAME="localhost"
export ORION_PORT="10026"

### Orion PEP related variables
export ORION_PEP_USER="chanchan"
export ORION_PEP_HOME="fiware-orion-pep"

### Orion related variables
export KEYPASS_USER="chanchan"
export KEYPASS_HOME="fiware-keypass"
export KEYPASS_DBNAME="keypass"
export KEYPASS_DBUSER="keypass"
export KEYPASS_DBPASS="keypass"

## Revisions to use on git repos: v1.0
export GIT_REV_CHANCHAN=f2c36f0d4a790309cdae2be2d8f94b1967821e07
export GIT_REV_CYGNUS=c797a60dabbd0bfc5e90c83efa9c15fed1bc1bd4
export GIT_REV_IDM=99c9591c8b547583946af08d2f4c77b1db6719fd
export GIT_REV_KEYPASS=431ea3c83d0ebc8809391f136e2b00954f0c014b
export GIT_REV_ORION=1e8518d6ebe1a49695c85d4535ae32bf3279927e
export GIT_REV_ORION_PROXYCOAP=749e22376664dd3adae17492090e58882d3b28a7
export GIT_REV_ORION_PEP=6b80dfae6a0c06eeae66d716a9a3db69371b615b

if [ "${DIST_TYPE}" == "redhat" ]; then
    # when not using packages for maven, add it to the path
    export M2_HOME=/opt/maven
    export PATH=${M2_HOME}/bin:${PATH}
fi
