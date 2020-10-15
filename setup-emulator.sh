#!/bin/bash
docker build -t setup-emu_docker -f ./tfg-setup/emu-setup-dockerfile .
docker run --rm -it -v $(pwd)/tfg-elastest-emulator:/tmp/emu-docker -v /var/run/docker.sock:/var/run/docker.sock setup-emu_docker
docker rmi setup-emu_docker