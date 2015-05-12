#!/bin/bash

export KEYPASS_SCRIPTS="${SCRIPTS_PATH}/keypass"

su - ${KEYPASS_USER} <<EOF
# this is needed to be able to use the variables with the ${KEYPASS_USER} user
export SCRIPTS_PATH=${SCRIPTS_PATH}
export DIST_TYPE=${DIST_TYPE}
source ${SCRIPTS_PATH}/variables.sh
for f in \$( ls ${KEYPASS_SCRIPTS}/*.sh ) ; do
    bash \${f}
done
EOF
