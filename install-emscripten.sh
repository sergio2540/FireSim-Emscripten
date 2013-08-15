#!/usr/bin/env bash


sudo apt-get install git curl subversion cmake build-essential default-jre scons -y
SCRIPT_URL=https://gist.github.com/shovon/6151878/raw/62c4f4b5733e772b5a627aebd2b0b32d7cd4ab1e/gistfile1.sh
mkdir llvm-src
cd llvm-src
curl $SCRIPT_URL | sh
clang --version
rm ~/.emscripten
rm -rf ~/.emscripten_cache
cd ./emscripten
git checkout master
./emcc --help
./emcc tests/hello_world.cpp
node a.out.js
