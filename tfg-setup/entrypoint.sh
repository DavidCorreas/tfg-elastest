#!/bin/bash
source /tmp/emu-docker/configure.sh
emu-docker interactive
./create_web_container.sh -p tfg-elastest,hello