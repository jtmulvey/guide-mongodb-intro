#!/bin/bash
set -euxo pipefail

##############################################################################
##
##  GH actions CI test script
##
##############################################################################

cd ..

# Build mongo docker image and run it
docker build -t mongo-sample -f assets/Dockerfile .
docker run --name mongo-guide -p 27017:27017 -d mongo-sample

## Wait for mongo to be ready
sleep 10

# copy truststore from container to host
docker cp mongo-guide:/home/mongodb/certs/truststore.p12 start/crew/src/main/liberty/config/resources/security
docker cp mongo-guide:/home/mongodb/certs/truststore.p12 finish/crew/src/main/liberty/config/resources/security

## Move back to the finish folder
cd finish

# LMP 3.0+ goals are listed here: https://github.com/OpenLiberty/ci.maven#goals

## Rebuild the application
#       package                   - Take the compiled code and package it in its distributable format.
#       liberty:create            - Create a Liberty server.
#       liberty:install-feature   - Install a feature packaged as a Subsystem Archive (esa) to the Liberty runtime.
#       liberty:deploy            - Copy applications to the Liberty server's dropins or apps directory. 
mvn -Dhttp.keepAlive=false \
    -Dmaven.wagon.http.pool=false \
    -Dmaven.wagon.httpconnectionManager.ttlSeconds=120 \
    -q clean package liberty:create liberty:install-feature liberty:deploy

## Run the tests
# These commands are separated because if one of the commands fail, the test script will fail and exit. 
# e.g if liberty:start fails, then there is no need to run the failsafe commands. 
#       liberty:start             - Start a Liberty server in the background.
#       failsafe:integration-test - Runs the integration tests of an application.
#       liberty:stop              - Stop a Liberty server.
#       failsafe:verify           - Verifies that the integration tests of an application passed.
mvn liberty:start
mvn failsafe:integration-test liberty:stop
mvn failsafe:verify
