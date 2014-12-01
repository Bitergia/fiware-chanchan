#!/bin/bash

chanchan@server:~/fiware-keypass$ java -jar target/keypass-0.3.0.jar server conf/config.yml &

function start_keypass () {
    keypass_pid=$( ps ax | grep java | grep keypass | awk '{print $1}' )
    if [ ! -z ${keypass_pid} ]; then
	echo "Stopping KeyPass"
	kill ${keypass_pid}
    fi
}


function start_keypass () {
    echo "Starting KeyPass"
    nohup java -jar ${HOME}/${KEYPASS_HOME}/target/keypass-0.3.0.jar  \
      server ${HOME}/${KEYPASS_HOME}/conf/config.yml &
}

stop_keypass
start_keypass
