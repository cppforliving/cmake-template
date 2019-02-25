#!/bin/bash

conan_config=Release
cmake_config=Release
valgrind=memcheck

while (( $# )); do
    case $1 in
    Clean)
        clean=1
        shift 1
        ;;
    Debug)
        conan_config=Debug
        cmake_config=$1
        shift 1
        ;;
    Release|MinSizeRel|RelWithDebInfo)
        conan_config=Release
        cmake_config=$1
        shift 1
        ;;
    Coverage)
        coverage=$2
        shift 2
        ;;
    MemCheck)
        memcheck=1
        valgrind=$2
        shift 2
        ;;
    Sanitizer)
        sanitizer=$2
        shift 2
        ;;
    *)
        echo "unknown option '$1'"
        exit 1
    esac
done

build_dir=build/$cmake_config
make_cmd="make -C $build_dir --no-print-directory"

set -e
[[ -z $clean ]] || rm -rf build
mkdir -p $build_dir
conan install -s build_type=$conan_config -s compiler.libcxx=libstdc++11 -if $build_dir .
cmake -DCMAKE_BUILD_TYPE=$cmake_config -Dprojname_coverage=$coverage -Dprojname_valgrind=$valgrind -Dprojname_sanitizer=$sanitizer -B$build_dir -H.
$make_cmd format
$make_cmd all
if [[ ! -z $memcheck ]]; then
    $make_cmd ExperimentalMemCheck
else
    $make_cmd ExperimentalTest
    [[ -z $coverage ]] || $make_cmd ExperimentalCoverage
fi
