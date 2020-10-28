#!/bin/bash
current_dir="$(dirname $(realpath "$0"))"

# Setup emulator
docker build -t wait-for-angular -f $current_dir/wget-dockerfile $current_dir
docker run --rm -it --network tfg-elastest_sut wait-for-angular
docker rmi wait-for-angular