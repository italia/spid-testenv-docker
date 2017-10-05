#!/bin/bash

# Start & Stop Identity Server to bootstrap it
sh /spid-testenvironment/is/identity-server/bin/wso2server.sh > /dev/null &
until $(curl --output /dev/null --silent --head --fail http://localhost:9443); do
    printf '...'
    sleep 3
done
sh /spid-testenvironment/is/identity-server/bin/wso2server.sh stop > /dev/null &

# Move files


# Run backoffice
cd /spid-testenvironment/bo/backoffice
npm run start-prod &