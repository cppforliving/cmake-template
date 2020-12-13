cmake_minimum_required(VERSION 3.16)

get_property(cmake_role GLOBAL PROPERTY CMAKE_ROLE)
if(NOT cmake_role STREQUAL "SCRIPT")
    message(FATAL_ERROR "Not supported CMAKE_ROLE=${cmake_role}")
endif()

include(CMakePrintHelpers)
include(${CMAKE_CURRENT_LIST_DIR}/../cmake/ScriptUtils.cmake)

set(package_managers conan vcpkg)
if(package_manager AND NOT package_manager IN_LIST package_managers)
    message(FATAL_ERROR "unknown 'package_manager' value '${package_manager}'")
endif()
cmake_print_variables(package_manager)

set(build_types Debug Release)
if(build_type AND NOT build_type IN_LIST build_types)
    message(FATAL_ERROR "unknown 'build_type' value '${build_type}'")
endif()
cmake_print_variables(build_type)

if(NOT build_dir)
    message(FATAL_ERROR "missing 'build_dir' value")
endif()
file(TO_CMAKE_PATH "${build_dir}" build_dir)
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

set(conan_dir "${build_dir}/conan")
if(package_manager STREQUAL "conan")
    eval(${CMAKE_COMMAND} -E make_directory "${conan_dir}")
    eval(conan --version)
    eval(conan profile new
        --detect --force
        "${conan_dir}/conanprofile.txt")
    eval(conan profile update
        settings.compiler.cppstd=20
        "${conan_dir}/conanprofile.txt")
    eval_out(conan_detected_libcxx
        conan profile get
        settings.compiler.libcxx
        "${conan_dir}/conanprofile.txt")
    if(conan_detected_libcxx STREQUAL "libstdc++")
        eval(conan profile update
            settings.compiler.libcxx=libstdc++11
            "${conan_dir}/conanprofile.txt")
    endif()
    eval(conan install . "${update_flag}"
        -if "${conan_dir}"
        -s "build_type=${build_type}"
        -pr "${conan_dir}/conanprofile.txt"
        -b outdated)
elseif(package_manager STREQUAL "vcpkg")
    file(TO_CMAKE_PATH "$ENV{VCPKG_ROOT}" vcpkg_root)
    eval("${vcpkg_root}/vcpkg" version)
    if(update)
        eval("${vcpkg_root}/vcpkg" update)
    endif()
endif()
