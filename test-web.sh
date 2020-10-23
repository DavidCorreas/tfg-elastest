#!/bin/bash

current_dir="$(dirname $(realpath "$0"))"

function printAndSleep {
	((counter++))
	echo "
	###### $1 ######
	"
	sleep 1
}

# Levantamos infrastructura para el test
printAndSleep " <--- SETUP ---> "
./selenoid-sut.sh

TEST=W_posts.robot
if [ ! -z $1 ]; then
    TEST=$1
fi

RESULTS_DIR=$current_dir/test-results
mkdir -p $RESULTS_DIR

echo "
HOST_UID_GID=$(id -u):$(id -g)
node_workspace_windows=$RESULTS_DIR
browser=chrome
version=85.0
country=es
environment=TEST
remote_url=http://selenoid:4444/wd/hub
remote_url_mob=
test_cases=
test_suite=$TEST
" > $current_dir/tfg-elastest-test/tfg-elastest-test-robotframework/Local/.env

printAndSleep "Ejecutamos test: $TEST (http://localhost:9090)"
bash ./tfg-elastest-test/tfg-elastest-test-robotframework/Local/run_test.sh

# Paramos infrastructura.
printAndSleep " <--- TEARDOWN ---> "
./selenoid-sut.sh down