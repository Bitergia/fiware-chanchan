#!/bin/bash

su - idm-source <<EOF
cd fi-ware-idm
cap production deploy
EOF
