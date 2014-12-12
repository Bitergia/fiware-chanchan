#!/bin/bash

function stop_orion_pep () {
    orion_pep_pid=$( ps ax | grep pepProxy | grep bin | awk '{print $1}' )
    echo ${orion_pep_pid}
    if [ ! -z ${orion_pep_pid} ]; then
	echo "Stopping Orion PEP"
	kill ${orion_pep_pid}
	# killall contextBroker
    fi
}


function start_orion_pep () {
    echo "Starting Orion PEP "
    # nohup ${HOME}/bin/contextBroker --port 10026 > ${HOME}/contextbroker.log 2>&1 < /dev/null &
    cd ${HOME}/${ORION_PEP_HOME}/
    NODE_TLS_REJECT_UNAUTHORIZED=0  nohup bin/pepProxy &
    cd ${HOME}
}

stop_orion_pep
start_orion_pep
