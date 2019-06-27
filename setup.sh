#!/bin/bash

set -e

SETUP_NAME=jenkins-setup

# Get User/Password from env or prompt user
if [[ -z $JENKINS_USER ]]; then
	echo "Enter a Jenkins login username"
	read JENKINS_USER
	export JENKINS_USER
fi
if [[ -z $JENKINS_PASS ]]; then
	echo "Enter a Jenkins login password"
	read -s JENKINS_PASS
	export JENKINS_PASS
fi

docker-compose -f $SETUP_NAME.yaml up -d

echo "Waiting for Jenkins to complete setup..."
echo ""
until [[ $(docker logs $SETUP_NAME 2>&1 | grep "Jenkins is fully up and running") != "" ]]; do
	sleep 5
done

# Get plugins
# curl -s -k "http://admin:admin@localhost:8080/pluginManager/api/json?depth=1" | jq -r '.plugins[].shortName' | tee jenkins_plugins.txt

docker-compose -f $SETUP_NAME.yaml down

# Bring up Jenkins
docker-compose up -d

echo "You can now login to Jenkins at http://localhost:8080"
echo ""
echo "Username: $JENKINS_USER"
echo "Password: $JENKINS_PASS"