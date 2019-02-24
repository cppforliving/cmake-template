#!/bin/bash

build_type=Release  # Conan default
valgrind=memcheck   # CTest default

while (( $# )); do
    case $1 in
    Clean)
        clean=1
        offset=1
        ;;
    Debug|Release|RelWithDebInfo|MinSizeRel)
        build_type=$1
        offset=1
        ;;
    Coverage)
        coverage=$2
        offset=2
        ;;
    MemCheck)
        memcheck=1
        valgrind=$2
        offset=2
        ;;
    Sanitize)
        sanitize=$2
        offset=2
        ;;
    *)
        echo "unknown option '$1'"
        exit 1
    esac
    shift $offset
done

build_dir=build/$build_type
make_cmd="make -C $build_dir --no-print-directory"

if [[ ! -z $clean ]]; then
    rm -rf build
fi
mkdir -p $build_dir
conan install -s build_type=$build_type -s compiler.libcxx=libstdc++11 -if $build_dir .
cmake -DCMAKE_BUILD_TYPE=$build_type -Dprojname_coverage=$coverage -Dprojname_valgrind=$valgrind -Dprojname_sanitizer=$sanitize -B$build_dir -H.
$make_cmd format
$make_cmd all
if [[ ! -z $memcheck ]]; then
    $make_cmd ExperimentalMemCheck
else
    $make_cmd ExperimentalTest
    if [[ ! -z $coverage ]]; then
        $make_cmd ExperimentalCoverage
    fi
fi
