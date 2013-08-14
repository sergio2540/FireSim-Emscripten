#!/usr/bin/env bash


sudo apt-get install git subversion cmake build-essential default-jre scons
cd ~
svn co http://llvm.org/svn/llvm-project/llvm/tags/RELEASE_32/final llvm32
cd llvm32/tools
svn co http://llvm.org/svn/llvm-project/cfe/tags/RELEASE_32/final clang
cd ../..
mkdir llvm32build
cd llvm32build
cmake -DCMAKE_BUILD_TYPE=Release -G "Unix Makefiles" ../llvm32
make
cd ~
echo "export PATH=~/llvm32build/bin:\$PATH" >> .bashrc
cd ~
clang --version
rm ~/.emscripten
rm -rf ~/.emscripten_cache
cd ./emscripten
git checkout master
./emcc --help