#!/bin/bash

mode="up -d --build"
if [ ! -z $1 ]; then
    if [ $1 == "down" ];then
        mode=down
    fi
fi

function printAndSleep {
	((counter++))
	echo "
	###### $1 ######
	"
	sleep 1
}

# Levantamos sut, con los endpoints configurados para que 
# funcionen en los navegadores de selenoid
if [ "$mode" != "down" ]; then
    docker network create tfg-elastest_envoymesh
    printAndSleep "SUT (only works through selenoid, http://localhost:9090)"
    docker-compose -f tfg-elastest-sut/docker-compose.yml -f tfg-elastest-sut/production-compose.yml $mode

# Descargamos los navegadores que usa selenoid
    printAndSleep "PULL CHROME"
    docker pull tfgelastest/chrome-vnc:85.0
fi

# Levantamos selenoid y selenoid-ui
printAndSleep "SELENOID"
docker-compose -f ./tfg-elastest-test/selenoid/docker-compose.yml $mode


# Paramos sut ya que es propietaria de la red
if [ "$mode" == "down" ]; then
    printAndSleep "SUT"
    docker-compose -f ./tfg-elastest-sut/docker-compose.yml -f ./tfg-elastest-sut/production-compose.yml $mode
fi