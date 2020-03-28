cmake_minimum_required(VERSION 3.15)

get_property(cmake_role GLOBAL PROPERTY CMAKE_ROLE)
if(NOT cmake_role STREQUAL "SCRIPT")
    message(FATAL_ERROR "Not supported CMAKE_ROLE=${cmake_role}")
endif()

include(CMakePrintHelpers)
include(${CMAKE_CURRENT_LIST_DIR}/../cmake/ProjectUtils.cmake)

set(package_managers conan vcpkg)
if(NOT package_manager)
    message(FATAL_ERROR "'package_manager' unspecified")
elseif(NOT package_manager IN_LIST package_managers)
    message(FATAL_ERROR "unknown 'package_manager' value '${package_manager}'")
endif()
cmake_print_variables(package_manager)

set(build_types Debug Release)
if(NOT build_type)
    set(build_type Release)
elseif(NOT build_type IN_LIST build_types)
    message(FATAL_ERROR "unknown 'build_type' value '${build_type}'")
endif()
cmake_print_variables(build_type)

if(NOT build_dir)
    set(build_dir ./build/${build_type})
endif()
cmake_print_variables(build_dir)

if(NOT update)
    set(update OFF)
    set(update_flag)
else()
    set(update_flag -u)
endif()
cmake_print_variables(update)

if(NOT clean)
    set(clean OFF)
endif()
cmake_print_variables(clean)

if(clean AND EXISTS "${build_dir}")
    eval(${CMAKE_COMMAND} -E remove_directory "${build_dir}")
endif()
eval(${CMAKE_COMMAND} -E make_directory "${build_dir}")

if(package_manager STREQUAL "conan")
    eval(conan --version)
    eval(conan profile new
        --detect --force
        "${build_dir}/conan_profile")
    eval_out(conan_detected_libcxx
        conan profile get
        settings.compiler.libcxx
        "${build_dir}/conan_profile")
    if(conan_detected_libcxx STREQUAL "libstdc++")
        eval(conan profile update
            settings.compiler.libcxx=libstdc++11
            "${build_dir}/conan_profile")
    endif()
    eval(conan install . "${update_flag}"
        -if "${build_dir}"
        -s "build_type=${build_type}"
        -pr "${build_dir}/conan_profile"
        -b missing)
elseif(package_manager STREQUAL "vcpkg")
    file(TO_CMAKE_PATH $ENV{VCPKG_ROOT} vcpkg_root)
    eval("${vcpkg_root}/vcpkg" version)
    eval("${vcpkg_root}/vcpkg" install @vcpkgfile.txt)
endif()
