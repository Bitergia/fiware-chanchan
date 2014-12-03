#!/bin/bash

export CYGNUS_SCRIPTS="${SCRIPTS_PATH}/cygnus"

su - ${CYGNUS_USER} <<EOF
# this is needed to be able to use the variables with the ${CYGNUS_USER} user
source ${SCRIPTS_PATH}/variables.sh
for f in \$( ls ${CYGNUS_SCRIPTS}/*.sh ) ; do
    bash \${f}
done
EOF
