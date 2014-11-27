#!/bin/bash

function stop_cygnus () {
    cygnus_pid=$( ps ax | grep java | grep cygnusagent | awk '{print $1}' )
    kill ${cygnus_pid}
}


function start_cygnus () {
    ${HOME}/${APACHE_FLUME_HOME}/bin/flume-ng \
	agent \
	--conf ${HOME}/${APACHE_FLUME_HOME}/conf \
	-f ${HOME}/${APACHE_FLUME_HOME}/conf/cygnus.conf \
	-n cygnusagent \
	-Dflume.root.logger=INFO,console &
}

stop_cygnus
start_cygnus
