#!/bin/bash

# Definimos las variables de entorno que no estan en el contexto del docker-compose
set -a
source tfg-elastest-test/emu-docker.env

# Iniciamos el docker
cd tfg-elastest-emulator/
docker-compose -f js/docker/docker-compose.yaml -f js/docker/development.yaml -f ../tfg-elastest-test/compose-grid.yml up -d
