#!/bin/bash

export CYGNUS_SCRIPTS="${SCRIPTS_PATH}/cygnus"

for f in $( ls ${CYGNUS_SCRIPTS}/* ) ; do
    su - ${CYGNUS_USER} -c "bash ${f}"
done
