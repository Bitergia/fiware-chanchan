#!/bin/bash

export CC_SCRIPTS="${SCRIPTS_PATH}/chanchan"

for f in $( ls ${CC_SCRIPTS}/* ) ; do
    bash ${f}
done
