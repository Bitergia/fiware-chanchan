#!/bin/bash

export KEYPASS_SCRIPTS="${SCRIPTS_PATH}/keypass"

su - ${KEYPASS_USER} <<EOF
# this is needed to be able to use the variables with the ${KEYPASS_USER} user
source ${SCRIPTS_PATH}/variables.sh
for f in \$( ls ${KEYPASS_SCRIPTS}/* ) ; do
    bash \${f}
done
EOF
