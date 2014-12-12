#!/bin/bash

export IDM_SCRIPTS="${SCRIPTS_PATH}/idm"

for f in $( ls ${IDM_SCRIPTS}/*.sh ) ; do
    bash ${f}
done
