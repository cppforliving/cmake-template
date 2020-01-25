#!/usr/bin/env bash
set -euo pipefail

function run_main() {
    declare -rx CTEST_OUTPUT_ON_FAILURE=1
    declare conan_config=Release
    declare cmake_config=Release
    declare -i cmake_shared=1

    declare check=
    declare -i clean=
    declare cmake_toolchain=
    declare coverage=
    declare -i doc=
    declare -i examples=
    declare -i format=
    declare -i install=
    declare memcheck=
    declare package_manager=
    declare pip_upgrade=
    declare -i rpaths=
    declare sanitizer=
    declare -i stats=
    declare -i testing=
    declare -i benchmark=
    declare -i upgrade=

    declare opt
    for opt in "${@}"; do
        case ${opt} in
        Conan)
            declare -r package_manager=conan
            ;;
        Vcpkg)
            declare -r package_manager=vcpkg
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
            declare -r cmake_config=${opt}
            ;;
        Release | MinSizeRel | RelWithDebInfo)
            declare -r conan_config=Release
            declare -r cmake_config=${opt}
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
            declare -r memcheck=${opt#*=}
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
            declare -r upgrade=1
            declare -r pip_upgrade=-U
            ;;
        Verbose)
            declare -rx VERBOSE=1
            ;;
        Ninja)
            declare -rx CMAKE_GENERATOR=Ninja
            ;;
        *)
            echo >&2 "unknown option '${opt}'"
            exit 2
            ;;
        esac
    done

    declare -r venv_dir=./venv
    if [[ ! -d ${venv_dir} || ${pip_upgrade} ]]; then
        python3 -m venv "${venv_dir}"
    fi
    source "${venv_dir}/bin/activate"

    pip install $pip_upgrade -r requirements-dev.txt

    declare -r build_dir=./build/${cmake_config}

    cmake --warn-uninitialized \
        -D "package_manager=${package_manager}" \
        -D "build_type=${conan_config}" \
        -D "build_dir=${build_dir}" \
        -D "update=${upgrade}" \
        -D "clean=${clean}" \
        -P scripts/setup.cmake

    case ${package_manager} in
    conan)
        declare -r cmake_toolchain=${build_dir}/conan_paths.cmake
        ;;
    vcpkg)
        declare -r cmake_toolchain=${VCPKG_ROOT}/scripts/buildsystems/vcpkg.cmake
        ;;
    esac

    cmake \
        -B "${build_dir}" \
        -D "BUILD_SHARED_LIBS=${cmake_shared}" \
        -D "BUILD_TESTING=${testing}" \
        -D "BUILD_BENCHMARKS=${benchmark}" \
        -D "BUILD_EXAMPLES=${examples}" \
        -D "BUILD_DOCS=${doc}" \
        -D "CMAKE_BUILD_TYPE=${cmake_config}" \
        -D "CMAKE_TOOLCHAIN_FILE=${cmake_toolchain}" \
        -D "debug_dynamic_deps=${rpaths}" \
        -D "projname_coverage=${coverage}" \
        -D "projname_valgrind=${memcheck}" \
        -D "projname_sanitizer=${sanitizer}" \
        -D "projname_check=${check}"

    declare build_cmd
    build_cmd="cmake --build ${build_dir} --config ${cmake_config} --parallel $(nproc) -- $(
        if [[ ! -v CMAKE_GENERATOR || ${CMAKE_GENERATOR} == 'Unix Makefiles' ]]; then
            echo '--no-print-directory'
        fi
    )"
    declare -r build_cmd

    declare test_cmd
    test_cmd="cmake -E chdir ${build_dir} ctest --build-config ${cmake_config} $(
        if [[ -v VERBOSE ]]; then
            echo '--verbose'
        fi
    )"
    declare -r test_cmd

    if ((stats)); then
        ccache -z
    fi
    if ((format)); then
        ${build_cmd} format
    fi
    ${build_cmd} all
    if ((testing)); then
        if [[ -f "${build_dir}/activate_run.sh" ]]; then
            source "${build_dir}/activate_run.sh"
        fi
        if [[ ${memcheck} ]]; then
            ${test_cmd} ExperimentalMemCheck
        else
            ${test_cmd} ExperimentalTest
        fi
        if [[ -f "${build_dir}/deactivate_run.sh" ]]; then
            source "${build_dir}/deactivate_run.sh"
        fi
    fi
    if [[ ${coverage} ]]; then
        ${test_cmd} ExperimentalCoverage
    fi
    if ((doc)); then
        ${build_cmd} doc
    fi
    if ((install)); then
        cmake --install ${build_dir} --config ${cmake_config}
    fi
    if ((stats)); then
        ccache -s
    fi

    deactivate
}

if [[ "${0}" == "${BASH_SOURCE[0]}" ]]; then
    run_main "${@}"
fi
