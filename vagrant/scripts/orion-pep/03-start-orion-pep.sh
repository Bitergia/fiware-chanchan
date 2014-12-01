#!/bin/bash

function stop_orion_pep () {
    orion_pep_pid=$( ps ax | grep bin/pepProxy | awk '{print $1}' )
    if [ ! -z ${orion_pep_pid} ]; then
	echo "Stopping Orion PEP"
	kill ${orion_pep_pid}
	killall contextBroker
    fi
}


function start_keypass () {
    echo "Starting Orion PEP"
    nohup ${HOME}/bin/contextBroker --port 10026 > ${HOME}/contextbroker.log 2>&1 < /dev/null &
    nohup ${HOME}/${ORION_PEP_HOME}/bin/pepProxy
}

stop_orion_pep
start_orion_pep
