#!/bin/bash

# server hostname
export HOSTNAME="$(hostname -f)"

# interface for the public ip
export IFACE="eth1"

### IDM related variables

export IDM_HOSTNAME="idm.${HOSTNAME}"

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
export CHANCHAN_HOSTNAME="chanchan.${HOSTNAME}"
export CHANCHAN_APP_PATH="fiware-chanchan/server"
