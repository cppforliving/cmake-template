#!/usr/bin/env bash
set -euo pipefail

source_if_exists() {
    [[ ! -f $1 ]] || source "$@"
}

run_main() {
    declare conan_config=Release
    declare cmake_config=Release
    declare -i cmake_shared=1
    declare valgrind=memcheck

    declare check=
    declare -i clean=
    declare cmake_toolchain=
    declare conan_update=
    declare coverage=
    declare -i doc=
    declare -i examples=
    declare -i install=
    declare -i memcheck=
    declare package_manager=
    declare pip_upgrade=
    declare -i rpaths=
    declare sanitizer=
    declare -i stats=
    declare -i testing=
    declare -i benchmark=
    declare -i vcpkg_upgrade=

    declare opt
    for opt in "$@"; do
        case $opt in
        Conan)
            declare -r package_manager=conan
            ;;
        Vcpkg)
            declare -r package_manager=vcpkg
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
        Debug)
            declare -r conan_config=Debug
            declare -r cmake_config=$opt
            ;;
        Release | MinSizeRel | RelWithDebInfo)
            declare -r conan_config=Release
            declare -r cmake_config=$opt
            ;;
        Test)
            declare -r testing=1
            ;;
        Benchmark)
            declare -r benchmark=1
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
            declare -r vcpkg_upgrade=1
            ;;
        *)
            echo >&2 "unknown option '$opt'"
            exit 2
            ;;
        esac
    done

    declare -r build_dir=./build/$cmake_config
    [[ $clean == 1 ]] && [[ -d $build_dir ]] && rm -r "$build_dir"
    mkdir -p "$build_dir"

    declare -r venv_dir=./venv
    [[ ! -d $venv_dir || $pip_upgrade ]] && python3 -m virtualenv "$venv_dir"
    source "$venv_dir"/bin/activate

    pip install $pip_upgrade -r requirements-test.txt -r requirements-lint.txt

    case $package_manager in
    conan)
        declare -r cmake_toolchain=$build_dir/conan_paths.cmake
        conan profile new "$build_dir"/conan/detected --detect --force
        conan profile update settings.compiler.libcxx=libstdc++11 \
            "$build_dir"/conan/detected
        conan install . $conan_update \
            -if "$build_dir" \
            -s build_type="$conan_config" \
            -pr "$build_dir"/conan/detected \
            -b missing
        ;;
    vcpkg)
        declare -r cmake_toolchain=$VCPKG_ROOT/scripts/buildsystems/vcpkg.cmake
        if ((vcpkg_upgrade)); then
            "$VCPKG_ROOT"/vcpkg update
        fi
        "$VCPKG_ROOT"/vcpkg install @vcpkgfile.txt
        ;;
    esac

    cmake \
        -B"$build_dir" \
        -DBUILD_SHARED_LIBS="$cmake_shared" \
        -DBUILD_TESTING="$testing" \
        -DBUILD_BENCHMARKS="$benchmark" \
        -DBUILD_EXAMPLES="$examples" \
        -DBUILD_DOCS="$doc" \
        -DCMAKE_BUILD_TYPE="$cmake_config" \
        -DCMAKE_TOOLCHAIN_FILE="$cmake_toolchain" \
        -Ddebug_dynamic_deps="$rpaths" \
        -Dprojname_coverage="$coverage" \
        -Dprojname_valgrind="$valgrind" \
        -Dprojname_sanitizer="$sanitizer" \
        -Dprojname_check="$check"

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
    test_cmd="cmake -E chdir $build_dir ctest --output-on-failure \
        $verbose_flag --target"
    declare -r test_cmd

    [[ $stats == 1 ]] && ccache -z
    $make_cmd all
    if ((testing)); then
        source_if_exists "$build_dir"/activate_run.sh
        if ((memcheck)); then
            $test_cmd ExperimentalMemCheck
        else
            $test_cmd ExperimentalTest \
                "$([[ $check == 'lint' ]] && echo '-L lint')"
        fi
        source_if_exists "$build_dir"/deactivate_run.sh
    fi
    [[ $coverage ]] && $test_cmd ExperimentalCoverage
    [[ $doc == 1 ]] && $make_cmd doc
    [[ $install == 1 ]] && $make_cmd install
    [[ $stats == 1 ]] && ccache -s

    deactivate
}

if [[ "$0" == "${BASH_SOURCE[0]}" ]]; then
    run_main "$@"
fi
