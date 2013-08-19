#!/usr/bin/env bash

sudo apt-get install cmake build-essential default-jre scons -y
wget http://llvm.org/releases/3.2/clang+llvm-3.2-x86-linux-ubuntu-12.04.tar.gz
tar -xvf clang+llvm-3.2-x86-linux-ubuntu-12.04.tar.gz
cd clang+llvm-3.2-x86-linux-ubuntu-12.04
export LLVM=./bin
cd ..
