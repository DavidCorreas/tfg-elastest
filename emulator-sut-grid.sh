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



#### INICIO DEL SCRIPT ####

# Definimos las variables de entorno que no estan en el contexto del docker-compose
set -a
source tfg-elastest-test/emu-docker.env

# Iniciamos el emulador y appium con selenium hub
if [ "$mode" != "down" ]; then
    $current_dir/emulator-grid.sh
fi

# Levanta el sut, tanto back como front web
$current_dir/sut-web.sh $mode

# Instala la aplicacion en el emulador
if [ "$mode" != "down" ]; then
    printAndSleep "Installing apk in emulator"
    install-apk
fi

# Destruimos el emulador y appium con selenium hub
if [ "$mode" == "down" ]; then
    $current_dir/emulator-grid.sh down
fi

exit 0