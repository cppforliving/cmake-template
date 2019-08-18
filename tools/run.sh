#!/bin/bash
set -eo pipefail

conan_config=Release
cmake_config=Release
cmake_shared=ON
valgrind=memcheck
conan_toolchain=conan_paths.cmake
vcpkg_toolchain="$VCPKG_ROOT"/scripts/buildsystems/vcpkg.cmake

for opt in "$@"; do
    case $opt in
    Conan)
        cmake_toolchain="$conan_toolchain"
        ;;
    Vcpkg)
        cmake_toolchain="$vcpkg_toolchain"
        ;;
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
    Release | MinSizeRel | RelWithDebInfo)
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
    Doc)
        doc=1
        ;;
    Stats)
        stats=1
        ;;
    Rpaths)
        rpaths=1
        ;;
    *)
        echo "unknown option '$opt'"
        exit 1
        ;;
    esac
done

build_dir=build/$cmake_config
make_cmd="cmake --build $build_dir -j $(nproc) --"

[[ -z $clean ]] || rm -rf build
mkdir -p "$build_dir"

venv_dir=~/.virtualenvs/"$(basename $PWD)"
python -m virtualenv "$venv_dir"
source "$venv_dir"/bin/activate

pip install -U -r requirements-dev.txt

case "$cmake_toolchain" in
"$conan_toolchain")
    pip install -U conan
    conan install . \
        -if "$build_dir" \
        -s build_type="$conan_config" \
        -pr conan/any-linux-gcc
    ;;
"$vcpkg_toolchain")
    vcpkg install @vcpkgfile.txt
    ;;
esac

cmake . \
    -B"$build_dir" \
    -GNinja \
    -DBUILD_SHARED_LIBS="$cmake_shared" \
    -DBUILD_TESTING="$testing" \
    -DCMAKE_BUILD_TYPE="$cmake_config" \
    -DCMAKE_TOOLCHAIN_FILE="$cmake_toolchain" \
    -Ddebug_dynamic_deps="$rpaths" \
    -Dprojname_coverage="$coverage" \
    -Dprojname_valgrind="$valgrind" \
    -Dprojname_sanitizer="$sanitizer" \
    -Dprojname_check="$check"

[[ -z $stats ]] || ccache -z
[[ -z $format ]] || $make_cmd format
$make_cmd all
[[ -f "$build_dir"/activate_run.sh ]] && source "$build_dir"/activate_run.sh
[[ -z $testing && -z $coverage ]] || CTEST_OUTPUT_ON_FAILURE=1 $make_cmd ExperimentalTest
[[ -f "$build_dir"/deactivate_run.sh ]] && source "$build_dir"/deactivate_run.sh
[[ -z $coverage ]] || CTEST_OUTPUT_ON_FAILURE=1 $make_cmd ExperimentalCoverage
[[ -f "$build_dir"/activate_run.sh ]] && source "$build_dir"/activate_run.sh
[[ -z $memcheck ]] || CTEST_OUTPUT_ON_FAILURE=1 $make_cmd ExperimentalMemCheck
[[ -f "$build_dir"/deactivate_run.sh ]] && source "$build_dir"/deactivate_run.sh
[[ -z $doc ]] || $make_cmd doc
[[ -z $install ]] || $make_cmd install
[[ -z $stats ]] || ccache -s

deactivate
