#!/bin/bash

su - idm-source <<EOF
cd fi-ware-idm
REVISION=${GIT_REV_IDM} cap production deploy
EOF
