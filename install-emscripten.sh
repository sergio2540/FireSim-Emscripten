#!/usr/bin/env bash


sudo apt-get install git subversion cmake build-essential default-jre scons clang-3.2 -y
clang --version
rm ~/.emscripten
rm -rf ~/.emscripten_cache
cd ./emscripten
git checkout master
./emcc --help
./emcc tests/hello_world.cpp
node a.out.js
