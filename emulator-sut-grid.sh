#!/bin/bash

# Definimos las variables de entorno que no estan en el contexto del docker-compose
set -a
source tfg-elastest-test/emu-docker.env

# Iniciamos el docker
docker-compose -f tfg-elastest-emulator/js/docker/docker-compose.yaml -f tfg-elastest-emulator/js/docker/development.yaml -f tfg-elastest-test/compose-grid.yml -p tfg-elastest --project-directory=. up -d --build


cd tfg-elastest-sut
docker-compose -p tfg-elastest up -d --build