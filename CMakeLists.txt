cmake_minimum_required(VERSION 3.18)

include(CMakePrintHelpers)

cmake_print_variables(CMAKE_VERSION)

if(CMAKE_TOOLCHAIN_FILE AND NOT EXISTS "${CMAKE_TOOLCHAIN_FILE}")
    message(FATAL_ERROR "CMAKE_TOOLCHAIN_FILE='${CMAKE_TOOLCHAIN_FILE}' does not exist")
endif()

option(BUILD_SHARED_LIBS
    "Global flag to cause `add_library()` to create shared libraries if on." ON)
option(CMAKE_EXPORT_COMPILE_COMMANDS
    "Enable/Disable output of compile commands during generation." ON)

project(projname
    VERSION 0.1.0
    DESCRIPTION "C++ x GTest/Catch2/Doctest x GCC/Clang/MSVC x CMake x Conan/Vcpkg x Linux/macOS/Windows"
    LANGUAGES CXX)

if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
    set(CMAKE_INSTALL_PREFIX "${CMAKE_BINARY_DIR}/dist" CACHE PATH
        "Install path prefix, prepended onto install directories." FORCE)
endif()

option(BUILD_TESTING "Build tests flag." OFF)
option(projname_examples "Build examples flag." OFF)
option(projname_docs "Build documentation flag." OFF)

list(APPEND CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/cmake")

set(CMAKE_FIND_PACKAGE_PREFER_CONFIG ON)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

set(CMAKE_CXX_VISIBILITY_PRESET hidden)
set(CMAKE_VISIBILITY_INLINES_HIDDEN ON)

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib")
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin")

include(CTest)

include(Diagnostics)
include(Warnings)
include(ProjectUtils)

if(NOT CMAKE_CXX_COMPILER_LAUNCHER AND UNIX AND NOT APPLE)
    find_program(ccache_command ccache)
    if(ccache_command)
        set(CMAKE_CXX_COMPILER_LAUNCHER "${ccache_command}")
        cmake_print_variables(CMAKE_CXX_COMPILER_LAUNCHER)
    endif()
endif()

set(PythonLibsNew_FIND_VERSION ${PYBIND11_PYTHON_VERSION})
find_package(pybind11 REQUIRED)
if(NOT TARGET pybind11::module)
    add_library(pybind11::module INTERFACE IMPORTED)
    set_target_properties(pybind11::module
      PROPERTIES INTERFACE_LINK_LIBRARIES pybind11::pybind11
    )
endif()
projname_print_target_properties(pybind11::pybind11 pybind11::module pybind11::embed)
add_subdirectory(external EXCLUDE_FROM_ALL)

include(Valgrind)
include(StaticChecks)
include(Sanitizers)
include(Coverage)
include(ProjectCxxHelpers)
include(ProjectPyHelpers)

add_subdirectory(src)

include(ProjectConfig)

add_subdirectory(tests)
add_subdirectory(examples)
add_subdirectory(docs)
