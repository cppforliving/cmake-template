cmake_minimum_required(VERSION 3.15)

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
    DESCRIPTION "C++ x GTest/Catch2 x GCC/Clang/MSVC x CMake x Conan/Vcpkg x Linux/macOS/Windows"
    LANGUAGES CXX)

if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
    set(CMAKE_INSTALL_PREFIX "${CMAKE_BINARY_DIR}/dist" CACHE PATH
        "Install path prefix, prepended onto install directories." FORCE)
endif()

list(APPEND CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/cmake")

set(CMAKE_FIND_PACKAGE_PREFER_CONFIG ON)

set(CMAKE_CXX_STANDARD 17)
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

function(print_target_properties tgts)
    cmake_print_properties(
      TARGETS
        ${tgts}
      PROPERTIES
        NAME
        TYPE
        IMPORTED
        INTERFACE_INCLUDE_DIRECTORIES
        INTERFACE_LINK_LIBRARIES
        INTERFACE_COMPILE_DEFINITIONS
        INTERFACE_COMPILE_OPTIONS
    )
endfunction()

find_package(pybind11 REQUIRED)
print_target_properties(pybind11)
add_subdirectory(external)

include(Valgrind)
include(Format)
include(StaticChecks)
include(Sanitizers)
include(Coverage)
include(ProjectCxxHelpers)
include(ProjectPyHelpers)

add_subdirectory(src)

include(ProjectConfig)

add_subdirectory(tests)

if(BUILD_EXAMPLES)
    add_subdirectory(examples)
endif()

if(BUILD_DOCS)
    add_subdirectory(docs)
endif()
