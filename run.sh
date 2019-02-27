#!/bin/bash

conan_config=Release
cmake_config=Release
valgrind=memcheck

for opt in $@; do
    case $opt in
    Clean)
        clean=1
        ;;
    Format)
        format=1
        ;;
    Debug)
        conan_config=Debug
        cmake_config=$opt
        ;;
    Release|MinSizeRel|RelWithDebInfo)
        conan_config=Release
        cmake_config=$opt
        ;;
    Test)
        testing=1
        ;;
    Coverage=*)
        coverage=${opt#*=}
        ;;
    MemCheck=*)
        memcheck=1
        valgrind=${opt#*=}
        ;;
    Sanitizer=*)
        sanitizer=${opt#*=}
        ;;
    Check=*)
        check=${opt#*=}
        ;;
    *)
        echo "unknown option '$opt'"
        exit 1
    esac
done

build_dir=build/$cmake_config
make_cmd="make -C $build_dir --no-print-directory"

set -e
[[ -z $clean ]] || rm -rf build
mkdir -p $build_dir
conan install -s build_type=$conan_config -s compiler.libcxx=libstdc++11 -if $build_dir .
cmake -DCMAKE_BUILD_TYPE=$cmake_config -Dprojname_coverage=$coverage -Dprojname_valgrind=$valgrind -Dprojname_sanitizer=$sanitizer -Dprojname_check=$check -B$build_dir -H.
[[ -z $format ]] || $make_cmd format
$make_cmd all
[[ -z $testing && -z $coverage ]] || $make_cmd ExperimentalTest
[[ -z $coverage ]] || $make_cmd ExperimentalCoverage
[[ -z $memcheck ]] || $make_cmd ExperimentalMemCheck
