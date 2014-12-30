#!/bin/bash

_iface=${1:-eth0}
ip addr | sed -n "/inet.*${_iface}/ s/^.*inet \(.*\)\/.*$/\1/p"
