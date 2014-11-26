#!/bin/bash

export CHANCHAN_SCRIPTS="${SCRIPTS_PATH}/chanchan"

for f in $( ls ${CHANCHAN_SCRIPTS}/* ) ; do
    bash ${f}
done
