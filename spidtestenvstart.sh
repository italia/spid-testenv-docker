#!/bin/bash

# Start & Stop Identity Server to bootstrap it
sh /spid-testenvironment/is/identity-server/bin/wso2server.sh
until $(curl --output /dev/null --silent --head --fail http://localhost:9443); do
    printf '.'
    wait
done
sh /spid-testenvironment/is/identity-server/bin/wso2server.sh stop &

# Move files


# Run backoffice
cd /spid-testenvironment/bo/backoffice
npm run start-prod &