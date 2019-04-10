# cmake-template

[![Travis Build Status](https://travis-ci.com/piotrgumienny/cmake-template.svg?branch=master)](https://travis-ci.com/piotrgumienny/cmake-template)
[![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/piotrgumienny/cmake-template?branch=master&svg=true)](https://ci.appveyor.com/project/piotrgumienny/cmake-template)
[![License](https://img.shields.io/github/license/piotrgumienny/cmake-template.svg)](LICENSE.md)

## How to build and test
Linux workflow:
```sh
mkdir build && cd build
conan install -b missing -s compiler.libcxx=libstdc++11 ..
cmake ..
make
ctest -V
```

## Project structure
* [cmake](cmake) - `CMake` modules
* [doc](doc) - documentation
* [src](src) - sources and unit tests
* [test](test) - integration/e2e tests

## Requirements
* CMake
* Git
* Python
* GoogleTest (downloads automatically from web during testing build)
* Valgrind (optional)
* Clang-Tidy (optional)
* Clang-Format (optional)
* Doxygen (optional)
* Graphviz (optional)
* PlantUML (optional)

## Supported platforms
* Linux
* Windows
* macOS

## Supported compilers
* Clang
* GCC
* MSVC
