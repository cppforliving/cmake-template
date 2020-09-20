#!/usr/bin/env bash
set -euo pipefail

source_if_exists() {
    set +u
    if [[ -f $1 ]]; then
        source "$@"
    fi
    set -u
}

run_main() {
    declare build_type=Debug
    declare -i cmake_shared=1
    declare valgrind=memcheck

    declare check=
    declare -i clean=
    declare toolchain=
    declare coverage=
    declare -i doc=
    declare -i examples=
    declare -i fuzzer=
    declare -i install=
    declare -i memcheck=
    declare package_manager=
    declare python_version=
    declare -i rpaths=
    declare sanitizer=
    declare -i stats=
    declare -i testing=
    declare -i update=

    declare opt
    for opt in "$@"; do
        case $opt in
        Conan)
            declare -r package_manager=conan
            declare -r toolchain=$conan_dir/conan_paths.cmake
            ;;
        Vcpkg)
            declare -r package_manager=vcpkg
            declare -r toolchain=$VCPKG_ROOT/scripts/buildsystems/vcpkg.cmake
            ;;
        Clean)
            declare -r clean=1
            ;;
        Static)
            declare -r cmake_shared=0
            ;;
        Shared)
            declare -r cmake_shared=1
            ;;
        Debug | Release)
            declare -r build_type=$opt
            ;;
        Test)
            declare -r testing=1
            ;;
        Fuzzer=*)
            declare -r fuzzer=${opt#*=}
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
        Python=*)
            declare -r python_version=${opt#*=}
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
        Update)
            declare -r update=1
            ;;
        *)
            echo >&2 "unknown option '$opt'"
            exit 2
            ;;
        esac
    done

    declare -r build_dir="$PWD"/build/"${build_type}"
    declare -r conan_dir="$build_dir"/conan

    cmake --warn-uninitialized \
        -D package_manager="$package_manager" \
        -D build_type="$build_type" \
        -D build_dir="$build_dir" \
        -D update="$update" \
        -D clean="$clean" \
        -P scripts/setup.cmake

    cmake \
        -B "$build_dir" \
        -D BUILD_SHARED_LIBS="$cmake_shared" \
        -D BUILD_TESTING="$testing" \
        -D projname_fuzzers="$fuzzer" \
        -D projname_examples="$examples" \
        -D CMAKE_BUILD_TYPE="$build_type" \
        -D CMAKE_TOOLCHAIN_FILE="$toolchain" \
        -D PYBIND11_PYTHON_VERSION="$python_version" \
        -D projname_debug_dynamic_deps="$rpaths" \
        -D projname_coverage="$coverage" \
        -D projname_valgrind="$valgrind" \
        -D projname_sanitizer="$sanitizer" \
        -D projname_check="$check"

    declare verbose_flag=
    if [[ -v VERBOSE ]]; then
        verbose_flag='--verbose'
    fi
    declare -r verbose_flag

    declare make_flag=
    if [[ ! -v CMAKE_GENERATOR || $CMAKE_GENERATOR == 'Unix Makefiles' ]]; then
        make_flag='--no-print-directory'
    fi
    declare -r make_flag

    declare make_cmd
    make_cmd="cmake --build $build_dir -j $(nproc) $verbose_flag -- $make_flag"
    declare -r make_cmd

    declare test_cmd
    test_cmd="cmake -E chdir $build_dir ctest -C $build_type \
        --output-on-failure $verbose_flag --target"
    declare -r test_cmd

    if ((stats)); then
        ccache -z
    fi
    $make_cmd all
    if ((testing)); then
        source_if_exists "$conan_dir"/activate_run.sh
        if ((memcheck)); then
            $test_cmd ExperimentalMemCheck
        else
            $test_cmd ExperimentalTest \
                "$(if [[ $check == 'lint' ]]; then
                    echo '-L lint'
                fi)"
        fi
        source_if_exists "$conan_dir"/deactivate_run.sh
    fi
    if [[ $coverage ]]; then
        $test_cmd ExperimentalCoverage
    fi
    if ((doc)); then
        $make_cmd doc
    fi
    if ((install)); then
        $make_cmd install
    fi
    if ((stats)); then
        ccache -s
    fi
}

if [[ "$0" == "${BASH_SOURCE[0]}" ]]; then
    run_main "$@"
fi
