cmake_minimum_required(VERSION 3.15)

get_property(cmake_role GLOBAL PROPERTY CMAKE_ROLE)
if(NOT cmake_role STREQUAL "SCRIPT")
    message(FATAL_ERROR "Not supported CMAKE_ROLE=${cmake_role}")
endif()

include(CMakePrintHelpers)

macro(eval)
    execute_process(COMMAND ${ARGN} COMMAND_ECHO STDOUT RESULT_VARIABLE ret)
    if(ret)
        string(REPLACE ";" " " msg "'${ARGN}' failed with error code ${ret}")
        message(FATAL_ERROR "${msg}")
    endif()
endmacro()

set(ENV{CTEST_OUTPUT_ON_FAILURE} 1)
set(cmake_config Release)
set(cmake_shared 1)

set(cmake_release_configs Release MinSizeRel RelWithDebInfo)
if(cmake_config STREQUAL "Debug")
    set(conan_config Debug)
elseif(cmake_config IN_LIST cmake_release_configs)
    set(conan_config Release)
endif()

if(NOT upgrade)
    set(upgrade OFF)
    set(pip_upgrade)
else()
    set(pip_upgrade -U)
endif()

set(venv_dir ./venv)
if(NOT IS_DIRECTORY ${venv_dir} OR pip_upgrade)
    set(Python_FIND_FRAMEWORK NEVER)
    set(Python_FIND_REGISTRY NEVER)
    find_package(Python REQUIRED COMPONENTS Interpreter)
    eval(${Python_EXECUTABLE} -m virtualenv "${venv_dir}")
endif()
# eval(source "${venv_dir}/bin/activate")

eval(pip install --user ${pip_upgrade} -r requirements-dev.txt)

set(build_dir ./build/${cmake_config})

eval(${CMAKE_COMMAND} --warn-uninitialized
    -D "package_manager=${package_manager}"
    -D "build_type=${conan_config}"
    -D "build_dir=${build_dir}"
    -D "update=${upgrade}"
    -D "clean=${clean}"
    -P scripts/setup.cmake)

if(package_manager STREQUAL "conan")
    set(cmake_toolchain "${build_dir}/conan_paths.cmake")
elseif(package_manager STREQUAL "vcpkg")
    file(TO_CMAKE_PATH "$ENV{VCPKG_ROOT}" vcpkg_root)
    set(cmake_toolchain "${vcpkg_root}/scripts/buildsystems/vcpkg.cmake")
endif()

eval(${CMAKE_COMMAND}
    -B "${build_dir}"
    -D "BUILD_SHARED_LIBS=${cmake_shared}"
    -D "BUILD_TESTING=${testing}"
    -D "BUILD_BENCHMARKS=${benchmark}"
    -D "BUILD_EXAMPLES=${examples}"
    -D "BUILD_DOCS=${doc}"
    -D "CMAKE_BUILD_TYPE=${cmake_config}"
    -D "CMAKE_TOOLCHAIN_FILE=${cmake_toolchain}"
    -D "debug_dynamic_deps=${rpaths}"
    -D "projname_coverage=${coverage}"
    -D "projname_valgrind=${memcheck}"
    -D "projname_sanitizer=${sanitizer}"
    -D "projname_check=${check}")

set(build_cmd ${CMAKE_COMMAND} --build ${build_dir}
    --config ${cmake_config} --)#parallel $(nproc) --)
if((NOT DEFINED ENV{CMAKE_GENERATOR} AND NOT APPLE AND NOT WIN32)
  OR $ENV{CMAKE_GENERATOR} STREQUAL "Unix Makefiles")
    list(APPEND build_cmd --no-print-directory)
endif()

set(test_cmd ${CMAKE_COMMAND} -E chdir ${build_dir}
    ${CMAKE_CTEST_COMMAND} --build-config ${cmake_config})
if(DEFINED ENV{VERBOSE})
    list(APPEND test_cmd --verbose)
endif()

if(stats AND UNIX)
    eval(ccache -z)
endif()
if(format)
    eval(${build_cmd} format)
endif()
eval(${build_cmd})
if(testing)
    # if(EXISTS "${build_dir}/activate_run.sh")
    #     eval(source "${build_dir}/activate_run.sh")
    # endif()
    if(memcheck)
        eval(${test_cmd} ExperimentalMemCheck)
    else()
        eval(${test_cmd} ExperimentalTest)
    endif()
    # if(EXISTS "${build_dir}/deactivate_run.sh")
    #     eval(source "${build_dir}/deactivate_run.sh")
    # endif()
endif()
if(coverage)
    eval(${test_cmd} ExperimentalCoverage)
endif()
if(doc)
    eval(${build_cmd} doc)
endif()
if(install)
    eval(${CMAKE_COMMAND} --install ${build_dir} --config ${cmake_config})
endif()
if(stats AND UNIX)
    eval(ccache -s)
endif()

# eval(deactivate)
