#!/bin/bash

sh /spid-testenvironment/is/identity-server/bin/wso2server.sh > /dev/null &

cd /spid-testenvironment/bo/backoffice
npm run start-prod