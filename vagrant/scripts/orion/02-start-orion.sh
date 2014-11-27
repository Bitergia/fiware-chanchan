#!/bin/bash

function stop_orion () {
    killall contextBroker
}


function start_orion () {
    ${HOME}/bin/contextBroker &
}

stop_orion
start_orion
