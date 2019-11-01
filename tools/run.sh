#!/usr/bin/env bash
set -euo pipefail

main() {
    declare conan_config=Release
    declare cmake_config=Release
    declare -i cmake_shared=1
    declare valgrind=memcheck
    declare -i silenced=1

    declare check=
    declare -i clean=0
    declare cmake_generator=
    declare cmake_toolchain=
    declare conan_update=
    declare coverage=
    declare -i doc=0
    declare -i examples=0
    declare -i format=0
    declare -i install=0
    declare -i memcheck=0
    declare pip_upgrade=
    declare -i rpaths=0
    declare sanitizer=
    declare -i stats=0
    declare -i testing=0
    declare -i vcpkg_upgrade=0

    declare opt
    for opt in "$@"; do
        case $opt in
        Conan)
            declare -r cmake_toolchain=conan_paths.cmake
            ;;
        Vcpkg)
            declare -r cmake_toolchain=$VCPKG_ROOT/scripts/buildsystems/vcpkg.cmake
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
        Verbose)
            declare -r silenced=0
            ;;
        Ninja)
            declare -r cmake_generator=-GNinja
            ;;
        *)
            echo "unknown option '$opt'" >&2
            exit 1
            ;;
        esac
    done

    silent() {
        ((silenced)) || set +x
        "$@"
        ((silenced)) || set -x
    }
    readonly -f silent

    source_if_exists() {
        [[ ! -f $1 ]] || source "$@"
    }
    readonly -f source_if_exists

    ((silenced)) || set -x

    declare -r build_dir=./build/$cmake_config
    ((clean)) && rm -r "$build_dir"
    mkdir -p "$build_dir"

    declare -r venv_dir=./build/venv
    [[ ! -d $venv_dir || $pip_upgrade ]] && python -m virtualenv "$venv_dir"
    silent source "$venv_dir"/bin/activate

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
        if ((vcpkg_upgrade)); then
            "$VCPKG_ROOT"/vcpkg update
            "$VCPKG_ROOT"/vcpkg upgrade --no-dry-run
        fi
        "$VCPKG_ROOT"/vcpkg install @vcpkgfile.txt
        ;;
    esac

    cmake . \
        -B"$build_dir" \
        "$cmake_generator" \
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

    declare -r make_cmd="cmake --build $build_dir -j $(nproc) --"

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

if [[ "$0" == "${BASH_SOURCE[0]}" ]]; then
    main "$@"
fi
