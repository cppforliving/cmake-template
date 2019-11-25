#!/usr/bin/env bash
set -euo pipefail

run_main() {
    declare conan_config=Release
    declare cmake_config=Release
    declare -i cmake_shared=1
    declare valgrind=memcheck
    declare -i silenced=1

    declare check=
    declare -i clean=
    declare -Ar cmake_toolchains=(
        [conan]=conan_paths.cmake
        [vcpkg]=vcpkg.cmake
    )
    declare conan_update=
    declare coverage=
    declare -i doc=
    declare -i examples=
    declare -i format=
    declare -i install=
    declare -i memcheck=
    declare pip_upgrade=
    declare -i rpaths=
    declare sanitizer=
    declare -i stats=
    declare -i testing=
    declare -i vcpkg_upgrade=

    declare opt
    for opt in "$@"; do
        case $opt in
        Conan | Vcpkg)
            declare -r package_manager=${opt,,}
            ;;
        Clean)
            declare -r clean=1
            ;;
        Format)
            declare -r format=1
            ;;
        Static)
            declare -r cmake_shared=0
            ;;
        Shared)
            declare -r cmake_shared=1
            ;;
        Debug | Release)
            declare -r conan_config=$opt
            declare -r cmake_config=$opt
            ;;
        MinSizeRel | RelWithDebInfo)
            declare -r conan_config=Release
            declare -r cmake_config=$opt
            ;;
        Test)
            declare -r testing=1
            ;;
        Coverage=*)
            declare -r coverage=${opt#*=}
            ;;
        MemCheck=*)
            declare -r memcheck=1
            declare -r valgrind=${opt#*=}
            ;;
        Sanitizer=*)
            declare -r sanitizer=${opt#*=}
            ;;
        Check=*)
            declare -r check=${opt#*=}
            ;;
        Install)
            declare -r install=1
            ;;
        Examples)
            declare -r examples=1
            ;;
        Doc)
            declare -r doc=1
            ;;
        Stats)
            declare -r stats=1
            ;;
        Rpaths)
            declare -r rpaths=1
            ;;
        Upgrade)
            declare -r pip_upgrade=-U
            declare -r conan_update=-u
            ;;
        Verbose)
            declare -r silenced=0
            ;;
        Ninja)
            declare -rx CMAKE_GENERATOR=Ninja
            ;;
        *)
            echo "unknown option '$opt'" >&2
            exit 2
            ;;
        esac
    done

    silent() {
        ((silenced)) || set +x
        "$@"
        ((silenced)) || set -x
    }
    declare -fr silent

    source_if_exists() {
        [[ ! -f $1 ]] || source "$@"
    }
    declare -fr source_if_exists

    ((silenced)) || set -x

    declare -r build_dir=./build/$cmake_config
    ((clean)) && [[ -d $build_dir ]] && rm -r "$build_dir"
    mkdir -p "$build_dir"

    declare -r venv_dir=./venv
    [[ ! -d $venv_dir || $pip_upgrade ]] && python -m virtualenv "$venv_dir"
    silent source "$venv_dir"/bin/activate

    pip install $pip_upgrade -r requirements-dev.txt

    tools/setup.sh \
        --package_manager="$package_manager" \
        --build_type="$conan_config" \
        --build_dir="$build_dir" \
        "${conan_update:+--update}"

    cmake . \
        -B"$build_dir" \
        -DBUILD_SHARED_LIBS="$cmake_shared" \
        -DBUILD_TESTING="$testing" \
        -DBUILD_EXAMPLES="$examples" \
        -DBUILD_DOCS="$doc" \
        -DCMAKE_BUILD_TYPE="$cmake_config" \
        -DCMAKE_TOOLCHAIN_FILE="${cmake_toolchains[$package_manager]}" \
        -Ddebug_dynamic_deps="$rpaths" \
        -Dprojname_coverage="$coverage" \
        -Dprojname_valgrind="$valgrind" \
        -Dprojname_sanitizer="$sanitizer" \
        -Dprojname_check="$check"

    declare make_cmd
    make_cmd="cmake --build $build_dir --parallel $(nproc) --verbose --target"
    declare -r make_cmd

    ((stats)) && ccache -z
    ((format)) && $make_cmd format
    $make_cmd all
    if ((testing)); then
        silent source_if_exists "$build_dir"/activate_run.sh
        if ((memcheck)); then
            CTEST_OUTPUT_ON_FAILURE=1 $make_cmd ExperimentalMemCheck
        else
            CTEST_OUTPUT_ON_FAILURE=1 $make_cmd ExperimentalTest
        fi
        silent source_if_exists "$build_dir"/deactivate_run.sh
    fi
    [[ $coverage ]] && CTEST_OUTPUT_ON_FAILURE=1 $make_cmd ExperimentalCoverage
    ((doc)) && $make_cmd doc
    ((install)) && $make_cmd install
    ((stats)) && ccache -s

    silent deactivate
}
declare -fr main

if [[ "$0" == "${BASH_SOURCE[0]}" ]]; then
    run_main "$@"
fi
