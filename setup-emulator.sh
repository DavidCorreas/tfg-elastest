# #!/bin/bash
# Setup adb keys
ADB_USER=${USER}
ADB_HOME=${HOME}

if [ "$(find ~/.android -mindepth 1 2>/dev/null | wc -w)" -lt 3 ] 
then
    docker run --rm -v ~/.android:/root/.android tfgelastest/appium adb devices
    [ "$UID" -eq 0 ] || echo "Running root permissions to assign permissions to ~/.android"
    [ "$UID" -eq 0 ] || sudo chown -R $ADB_USER $ADB_HOME/.android && ./setup-emulator.sh
fi

# Setup emulator
[ "$UID" -eq 0 ] || echo "Running root permissions to build the container"
[ "$UID" -eq 0 ] || sudo docker build -t setup-emu_docker -f ./tfg-setup/emu-setup-dockerfile .
docker run --rm -it -v $(pwd)/tfg-elastest-emulator:/tmp/emu-docker -v $ADB_HOME/.android:/root/.android -v /var/run/docker.sock:/var/run/docker.sock setup-emu_docker && \
docker rmi setup-emu_docker
