#!/usr/bin/env bash


sudo apt-get install git curl subversion cmake build-essential default-jre scons -y
clang --version
cd ./emscripten
git checkout master
./emcc --help
./emcc tests/hello_world.cpp
node a.out.js
