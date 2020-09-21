# README

[![Travis Build Status](https://travis-ci.com/cppforliving/cmake-template.svg?branch=master)](https://travis-ci.com/cppforliving/cmake-template)
[![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/cppforliving/cmake-template?branch=master&svg=true)](https://ci.appveyor.com/project/cppforliving/cmake-template)
[![codecov](https://codecov.io/gh/cppforliving/cmake-template/branch/master/graph/badge.svg)](https://codecov.io/gh/cppforliving/cmake-template)
[![License](https://img.shields.io/github/license/cppforliving/cmake-template.svg)](./LICENSE)

## How to prepare environment

First time

```sh
python3 -m virtualenv venv
source venv/bin/activate
pip install -r requirements-dev.txt
deactivate
```

Next time

```sh
source venv/bin/activate
# configure, build, test, repeat
deactivate
```

## How to build and test

Linux workflow

```sh
mkdir build && cd build
conan install -b missing -s compiler.libcxx=libstdc++11 ..
cmake ..
make
ctest -V
```

## Project structure

- [cmake](./cmake) - `CMake` modules
- [docs](./docs) - documentation
- [examples](./examples) - code examples
- [external](./external) - dependencies
- [scripts](./scripts) - scripts and tools
- [src](./src) - sources and unit tests
- [tests](./tests) - integration tests

## Requirements

- CMake
- Git
- Python
- GoogleTest
- Valgrind (optional)
- Clang-Tidy (optional)
- Clang-Format (optional)
- Doxygen (optional)
- Graphviz (optional)

## Supported platforms

- Linux
- Windows
- macOS

## Supported compilers

- GCC 10
- Clang 10
- MSVC 19.20
- Apple Clang 11.0.3
