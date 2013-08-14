#!/usr/bin/env bash


sudo apt-get install git subversion cmake build-essential default-jre scons clang -y
clang --version
rm ~/.emscripten
rm -rf ~/.emscripten_cache
cd ./emscripten
git checkout master
./emcc --help
