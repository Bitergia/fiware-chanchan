#!/bin/bash

export ORION_SCRIPTS="${SCRIPTS_PATH}/orion"

for f in $( ls ${ORION_SCRIPTS}/* ) ; do
    su - ${ORION_USER} -c "bash ${f}"
done
