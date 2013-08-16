#!/usr/bin/env bash


sudo apt-get install git subversion cmake build-essential default-jre clang-3.2 scons -y
wget http://llvm.org/releases/3.2/clang+llvm-3.2-x86-linux-ubuntu-12.04.tar.gz
tar -xvf clang+llvm-3.2-x86-linux-ubuntu-12.04.tar.gz
cd clang+llvm-3.2-x86-linux-ubuntu-12.04
sudo cp -R ./bin/* /usr/bin
sudo cp -R ./include/* /usr/include
sudo cp -R ./lib/* /usr/lib
sudo cp -R ./lib/* /usr/share
cd ./emscripten
git checkout master
./emcc --help
cd ..
make c CC=cc
make run-c
make cp EMCC=../emscripten/emcc
cd ./crowdprocess/build 
ls

