#!/bin/bash

cd tfg-elastest-emulator/
docker-compose -f js/docker/docker-compose.yaml -f js/docker/development.yaml up -d

cd ../tfg-elastest-sut
docker-compose up -d