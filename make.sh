#!/bin/bash

if [ $1 = "make" ];
then
    rm -rf build
    docker run --rm -i -v ${PWD}:/build --name main_build  depthai_main_build:1.1 make html
elif [ $1 = "Docker" ];
then
    docker build -t depthai_main_build:1.1 ./
elif [ $1 = "server" ];
then
    cd build/html
    python -m http.server
fi