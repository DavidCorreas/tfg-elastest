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

function install-apk {
    rm /tmp/tmp-script.sh 2> /dev/null
    echo "#!/bin/bash" >> /tmp/tmp-script.sh
    echo -n "docker run " >> /tmp/tmp-script.sh
        echo -n "--rm " >> /tmp/tmp-script.sh
        echo -n "-v $(pwd)/tfg-elastest-sut/tfg-elastest-sut-cordova_app/apk:/opt/apk -v ~/.android:/root/.android -v $(pwd)/tfg-setup:/opt/setup " >> /tmp/tmp-script.sh
        echo -n "-e REMOTE_ADB=true -e ANDROID_DEVICES=${DEVICE_HOST}:${DEVICE_PORT} -e REMOTE_ADB_POLLING_SEC=3 -e ADB_INSTALL_TIMEOUT=10 " >> /tmp/tmp-script.sh
        echo -n "--network tfg-elastest_envoymesh " >> /tmp/tmp-script.sh
        echo -n "appium/appium " >> /tmp/tmp-script.sh
        echo "bash /opt/setup/install-apk.sh /opt/apk/app-debug.apk" >> /tmp/tmp-script.sh
    bash /tmp/tmp-script.sh
    rm /tmp/tmp-script.sh
}

function wait-for-device {
    rm /tmp/tmp-script.sh 2> /dev/null
    echo "#!/bin/bash" >> /tmp/tmp-script.sh
    echo -n "docker run " >> /tmp/tmp-script.sh
        echo -n "--rm -it " >> /tmp/tmp-script.sh
        echo -n "-v $(pwd)/tfg-setup:/opt -v ~/.android:/root/.android " >> /tmp/tmp-script.sh
        echo -n "-e REMOTE_ADB=true -e ANDROID_DEVICES=${DEVICE_HOST}:${DEVICE_PORT} -e REMOTE_ADB_POLLING_SEC=3 -e ADB_INSTALL_TIMEOUT=10 " >> /tmp/tmp-script.sh
        echo -n "--network tfg-elastest_envoymesh " >> /tmp/tmp-script.sh
        echo -n "appium/appium " >> /tmp/tmp-script.sh
        echo "/opt/appium-setup.sh" >> /tmp/tmp-script.sh
    bash /tmp/tmp-script.sh
    rm /tmp/tmp-script.sh
}

#### INICIO DEL SCRIPT ####

# Definimos las variables de entorno que no estan en el contexto del docker-compose
printAndSleep "Setting env variables"
set -a
source tfg-elastest-test/emu-docker.env

# Iniciamos el emulador
if [ "$mode" != "down" ]; then
    printAndSleep "Web emulator"
    docker-compose -f tfg-elastest-emulator/js/docker/docker-compose.yaml -f tfg-elastest-emulator/js/docker/development.yaml -p tfg-elastest --project-directory=. $mode
fi

# Appium espera a tener el emulador disponible para conectarse con el hub
if [ "$mode" != "down" ]; then
    printAndSleep "Wait for emulator"
    wait-for-device
fi
printAndSleep "Selenium Hub and Appium"
docker-compose -f tfg-elastest-test/compose-grid.yml --project-directory=. $mode

# Levanta el sut, tanto back como front web
printAndSleep "SUT"
cd tfg-elastest-sut
docker-compose $mode
cd ..

# Instala la aplicacion en el emulador
if [ "$mode" != "down" ]; then
    printAndSleep "Installing apk in emulator"
    install-apk
fi

# Elimina lo ultimo para que se elimine la red
if [ "$mode" == "down" ]; then
    printAndSleep "Web emulator"
    docker-compose -f tfg-elastest-emulator/js/docker/docker-compose.yaml -f tfg-elastest-emulator/js/docker/development.yaml -p tfg-elastest --project-directory=. $mode
fi
exit 0