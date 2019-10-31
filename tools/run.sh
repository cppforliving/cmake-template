#!/bin/bash
set -euo pipefail

conan_config=Release
cmake_config=Release
cmake_shared=1
valgrind=memcheck

check=
clean=
cmake_toolchain=
conan_update=
coverage=
doc=
examples=
format=
install=
memcheck=
pip_upgrade=
rpaths=
sanitizer=
stats=
testing=
vcpkg_upgrade=

for opt in "$@"; do
    case $opt in
    Conan)
        readonly cmake_toolchain=conan_paths.cmake
        ;;
    Vcpkg)
        readonly cmake_toolchain="$VCPKG_ROOT"/scripts/buildsystems/vcpkg.cmake
        ;;
    Clean)
        readonly clean=1
        ;;
    Format)
        readonly format=1
        ;;
    Static)
        readonly cmake_shared=
        ;;
    Shared)
        readonly cmake_shared=1
        ;;
    Debug)
        readonly conan_config=Debug
        readonly cmake_config=$opt
        ;;
    Release | MinSizeRel | RelWithDebInfo)
        readonly conan_config=Release
        readonly cmake_config=$opt
        ;;
    Test)
        readonly testing=1
        ;;
    Coverage=*)
        readonly coverage=${opt#*=}
        ;;
    MemCheck=*)
        readonly memcheck=1
        readonly valgrind=${opt#*=}
        ;;
    Sanitizer=*)
        readonly sanitizer=${opt#*=}
        ;;
    Check=*)
        readonly check=${opt#*=}
        ;;
    Install)
        readonly install=1
        ;;
    Examples)
        readonly examples=1
        ;;
    Doc)
        readonly doc=1
        ;;
    Stats)
        readonly stats=1
        ;;
    Rpaths)
        readonly rpaths=1
        ;;
    Upgrade)
        readonly pip_upgrade=-U
        readonly conan_update=-u
        readonly vcpkg_upgrade=1
        ;;
    *)
        echo "unknown option '$opt'" >&2
        exit 1
        ;;
    esac
done

readonly build_dir=./build/$cmake_config
readonly make_cmd="cmake --build $build_dir -j $(nproc) --"

[[ -z $clean ]] || rm -rf "$build_dir"
mkdir -p "$build_dir"

readonly venv_dir=~/.virtualenvs/"$(basename "$PWD")"
[[ -z $pip_upgrade ]] || python -m virtualenv "$venv_dir"
source "$venv_dir"/bin/activate

pip install $pip_upgrade -r requirements-dev.txt

case $(basename "$cmake_toolchain") in
conan_paths.cmake)
    pip install $pip_upgrade conan
    conan profile new "$build_dir"/conan/detected --detect --force
    conan profile update settings.compiler.libcxx=libstdc++11 "$build_dir"/conan/detected
    conan install . $conan_update \
        -if "$build_dir" \
        -s build_type="$conan_config" \
        -pr "$build_dir"/conan/detected \
        -b missing
    ;;
vcpkg.cmake)
    [[ -z $vcpkg_upgrade ]] || "$VCPKG_ROOT"/vcpkg update
    [[ -z $vcpkg_upgrade ]] || "$VCPKG_ROOT"/vcpkg upgrade --no-dry-run
    "$VCPKG_ROOT"/vcpkg install @vcpkgfile.txt
    ;;
esac

cmake . \
    -B"$build_dir" \
    -G"Unix Makefiles" \
    -DBUILD_SHARED_LIBS="$cmake_shared" \
    -DBUILD_TESTING="$testing" \
    -DBUILD_EXAMPLES="$examples" \
    -DBUILD_DOCS="$doc" \
    -DCMAKE_BUILD_TYPE="$cmake_config" \
    -DCMAKE_TOOLCHAIN_FILE="$cmake_toolchain" \
    -Ddebug_dynamic_deps="$rpaths" \
    -Dprojname_coverage="$coverage" \
    -Dprojname_valgrind="$valgrind" \
    -Dprojname_sanitizer="$sanitizer" \
    -Dprojname_check="$check"

source_if_exists() {
    [[ ! -f "$1" ]] || source "$@"
}
readonly -f source_if_exists

[[ -z $stats ]] || ccache -z
[[ -z $format ]] || $make_cmd format
$make_cmd all
source_if_exists "$build_dir"/activate_run.sh
[[ -z $testing && -z $coverage ]] || CTEST_OUTPUT_ON_FAILURE=1 $make_cmd ExperimentalTest
source_if_exists "$build_dir"/deactivate_run.sh
[[ -z $coverage ]] || CTEST_OUTPUT_ON_FAILURE=1 $make_cmd ExperimentalCoverage
source_if_exists "$build_dir"/activate_run.sh
[[ -z $memcheck ]] || CTEST_OUTPUT_ON_FAILURE=1 $make_cmd ExperimentalMemCheck
source_if_exists "$build_dir"/deactivate_run.sh
[[ -z $doc ]] || $make_cmd doc
[[ -z $install ]] || $make_cmd install
[[ -z $stats ]] || ccache -s

deactivate
