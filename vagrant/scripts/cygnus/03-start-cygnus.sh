#!/bin/bash

function stop_cygnus () {
    cygnus_pid=$( ps ax | grep java | grep cygnusagent | awk '{print $1}' )
    if [ ! -z ${cygnus_pid} ]; then
	echo "Stopping Cygnus"
	kill ${cygnus_pid}
    fi
}


function start_cygnus () {
    echo "Starting Cygnus"
    nohup ${HOME}/${APACHE_FLUME_HOME}/bin/flume-ng \
	  agent \
	  --conf ${HOME}/${APACHE_FLUME_HOME}/conf \
	  -f ${HOME}/${APACHE_FLUME_HOME}/conf/cygnus.conf \
	  -n cygnusagent \
	  -Dflume.root.logger=INFO,console > ${HOME}/flume.log 2>&1 < /dev/null &
}

stop_cygnus
start_cygnus
