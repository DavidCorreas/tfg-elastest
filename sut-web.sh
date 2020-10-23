#!/bin/bash

current_dir="$(dirname $(realpath "$0"))"

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

# Levanta el sut, tanto back como front web
printAndSleep "SUT"
docker-compose -f $current_dir/tfg-elastest-sut/docker-compose.yml -f $current_dir/tfg-elastest-sut/development-compose.yml --env-file=$current_dir/tfg-elastest-sut/.env $mode

exit 0