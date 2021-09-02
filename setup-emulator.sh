# #!/bin/bash
# Setup adb keys
ADB_USER=${USER}
ADB_HOME=${HOME}
SUDO=''
[ "$UID" -eq 0 ] || SUDO='sudo'

if [ "$(find ~/.android -mindepth 1 2>/dev/null | wc -w)" -lt 3 ] 
then
    docker run --rm -v ~/.android:/root/.android tfgelastest/appium adb devices
    [ "$UID" -eq 0 ] || echo "Running root permissions to assign permissions to ~/.android"
    $SUDO chown -R $ADB_USER $ADB_HOME/.android && ./setup-emulator.sh
fi

# Setup emulator
[ "$UID" -eq 0 ] || echo "Running root permissions to build the container"
$SUDO docker build -t setup-emu_docker -f ./tfg-setup/emu-setup-dockerfile .
$SUDO docker run --rm -it -v $(pwd)/tfg-elastest-emulator:/tmp/emu-docker -v $ADB_HOME/.android:/root/.android -v /var/run/docker.sock:/var/run/docker.sock setup-emu_docker && \
$SUDO docker rmi setup-emu_docker
