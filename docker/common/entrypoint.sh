#!/bin/sh
set -eux
cd workspace
cmake \
    -D build_dir="$HOME"/build \
    -D build_type=Release \
    -D package_manager="$PACKAGE_MANAGER" \
    -P scripts/setup.cmake
cmake \
    -B "$HOME"/build \
    -D CMAKE_BUILD_TYPE=Release \
    -D CMAKE_TOOLCHAIN_FILE="$CMAKE_TOOLCHAIN_FILE" \
    -D PYBIND11_PYTHON_VERSION=3 \
    -D BUILD_TESTING=ON \
    -D BUILD_BENCHMARKS=ON \
    -D BUILD_EXAMPLES=ON
cmake --build "$HOME"/build -j "$(nproc)"
cmake -E chdir "$HOME"/build ctest --output-on-failure -j "$(nproc)"
