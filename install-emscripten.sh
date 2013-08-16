#!/usr/bin/env bash


sudo apt-get install git curl subversion cmake build-essential default-jre clang-3.2 scons -y
clang --version
cd ./emscripten
git checkout master
./emcc --help
cd ..
make c CC=cc
make run-c
make cp EMCC=../emscripten/emcc
cd ./crowdprocess/build 
ls

