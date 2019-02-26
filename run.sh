#!/bin/bash

conan_config=Release
cmake_config=Release
valgrind=memcheck

for o in $@; do
    case $o in
    Clean)
        clean=1
        ;;
    Debug)
        conan_config=Debug
        cmake_config=$o
        ;;
    Release|MinSizeRel|RelWithDebInfo)
        conan_config=Release
        cmake_config=$o
        ;;
    Coverage=*)
        coverage=${o#*=}
        ;;
    MemCheck=*)
        memcheck=1
        valgrind=${o#*=}
        ;;
    Sanitizer=*)
        sanitizer=${o#*=}
        ;;
    *)
        echo "unknown option '$o'"
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
