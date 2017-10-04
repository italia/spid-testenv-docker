#!/bin/bash

trap "exit" INT TERM ERR
trap "kill 0" EXIT

sh /spid-testenvironment/is/identity-server/bin/wso2server.sh start &
sh /spid-testenvironment/is/identity-server/bin/wso2server.sh stop &

wait

