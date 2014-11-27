#!/bin/bash

function stop_orion () {
    killall contextBroker
}


function start_orion () {
    nohup ${HOME}/bin/contextBroker > ${HOME}/contextbroker.log 2>&1 < /dev/null &
}

stop_orion
start_orion
