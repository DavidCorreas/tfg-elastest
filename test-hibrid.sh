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
./emulator-grid.sh
./selenoid-sut.sh

# Esperamos a que la pagina este lista
printAndSleep " <--- WAIT FOR WEB PAGE ---> "
./tfg-setup/docker-for-wait-angular.sh

TEST=W_M_posts.robot

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
remote_url_mob=http://selenium_hub:4444/wd/hub
test_cases=
test_suite=$TEST
" > $current_dir/tfg-elastest-test/tfg-elastest-test-robotframework/Local/.env

printAndSleep "Ejecutamos test: $TEST (Emulador en: http://localhost)"
bash ./tfg-elastest-test/tfg-elastest-test-robotframework/Local/run_test_hibrid.sh

# Paramos infrastructura.
printAndSleep " <--- TEARDOWN ---> "
./selenoid-sut.sh down
./emulator-grid.sh down