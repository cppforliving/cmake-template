#!/bin/bash

conan_config=Release
cmake_config=Release
cmake_shared=ON
valgrind=memcheck

for opt in "$@"; do
    case $opt in
    Clean)
        clean=1
        ;;
    Format)
        format=1
        ;;
    Static)
        cmake_shared=OFF
        ;;
    Shared)
        cmake_shared=ON
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
    Install)
        install=1
        ;;
    Uninstall)
        uninstall=1
        ;;
    Doc)
        doc=1
        ;;
    *)
        echo "unknown option '$opt'"
        exit 1
    esac
done

build_dir=build/$cmake_config
make_cmd="cmake --build $build_dir -j $(nproc) --"

set -e
[[ -z $clean ]] || rm -rf build
mkdir -p "$build_dir"
conan install -s build_type="$conan_config" -s compiler.libcxx=libstdc++11 -if "$build_dir" .
cmake -DBUILD_SHARED_LIBS="$cmake_shared" -DBUILD_TESTING="$testing" -DCMAKE_BUILD_TYPE="$cmake_config" -Dprojname_coverage="$coverage" -Dprojname_valgrind="$valgrind" -Dprojname_sanitizer="$sanitizer" -Dprojname_check="$check" -B"$build_dir" -H.
[[ -z $format ]] || $make_cmd format
$make_cmd all
source "$build_dir"/activate_run.sh
[[ -z $testing && -z $coverage ]] || $make_cmd ExperimentalTest
source "$build_dir"/deactivate_run.sh
[[ -z $coverage ]] || $make_cmd ExperimentalCoverage
source "$build_dir"/activate_run.sh
[[ -z $memcheck ]] || $make_cmd ExperimentalMemCheck
source "$build_dir"/deactivate_run.sh
[[ -z $doc ]] || $make_cmd doc
[[ -z $install ]] || $make_cmd install
[[ -z $uninstall ]] || $make_cmd uninstall
