#!/bin/bash

# create database
cat <<EOF | mysql --user=root --password=${ROOT_DBPASSWD}
CREATE DATABASE ${IDM_DBNAME};
CREATE USER ${IDM_DBUSER}@localhost identified by '${IDM_DBPASS}';
GRANT ALL PRIVILEGES ON ${IDM_DBNAME}.* to ${IDM_DBUSER}@localhost;
FLUSH PRIVILEGES;
EOF
