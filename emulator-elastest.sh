#!/bin/bash

# Definimos las variables de entorno que no estan en el contexto del docker-compose
set -a
source tfg-elastest-test/emu-docker.env

# Iniciamos el docker
docker-compose -f tfg-elastest-emulator/js/docker/docker-compose.yaml -f tfg-elastest-emulator/js/docker/development.yaml -f tfg-elastest-elastest/compose-appium.yml --project-directory=. up -d
