#!/bin/bash

export IDM_SCRIPTS="${SCRIPTS_PATH}/idm"

for f in $( ls ${IDM_SCRIPTS}/* ) ; do
    bash ${f}
done
