#!/bin/bash

# remove old git
if [ -d "${KEYPASS_HOME}" ]; then
    rm -rf "${KEYPASS_HOME}"
fi

# get KeyPass
git clone https://github.com/telefonicaid/fiware-keypass.git ${KEYPASS_HOME}

# compile KeyPass
cd ${KEYPASS_HOME}
if [ "${GIT_REV_KEYPASS}" != "master" ]; then
    git checkout ${GIT_REV_KEYPASS}
fi
mvn clean package

# create database
cat <<EOF | mysql --user=root --password=${ROOT_DBPASSWD}
CREATE DATABASE ${KEYPASS_DBNAME};
CREATE USER ${KEYPASS_DBUSER}@localhost identified by '${KEYPASS_DBPASS}';
GRANT ALL PRIVILEGES ON ${KEYPASS_DBNAME}.* to ${KEYPASS_DBUSER}@localhost;
FLUSH PRIVILEGES;
EOF

# Load date in db
java -jar target/keypass-0.3.0.jar db migrate conf/config.yml

cd ..


