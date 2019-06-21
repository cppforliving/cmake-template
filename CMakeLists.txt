cmake_minimum_required(VERSION 3.14)
message(STATUS "CMake version: ${CMAKE_VERSION}")

option(BUILD_SHARED_LIBS
    "Global flag to cause `add_library()` to create shared libraries if on." ON)
option(CMAKE_EXPORT_COMPILE_COMMANDS
    "Enable/Disable output of compile commands during generation." ON)
option(CMAKE_INTERPROCEDURAL_OPTIMIZATION
    "Enable interprocedural optimization if supported by the compiler." OFF)

project(projname
    VERSION 0.1
    DESCRIPTION "CMake & Conan/Vcpkg based template for C/C++ projects."
    LANGUAGES C CXX)

if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
    set(CMAKE_INSTALL_PREFIX "${CMAKE_BINARY_DIR}/dist" CACHE PATH
        "Install path prefix, prepended onto install directories." FORCE)
endif()

set(CMAKE_SKIP_RPATH OFF)
set(CMAKE_MACOSX_RPATH OFF)

#list(INSERT CMAKE_MODULE_PATH 0 "${PROJECT_SOURCE_DIR}/cmake")
list(APPEND CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/cmake")

set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS OFF)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ${CMAKE_C_STANDARD_REQUIRED})
set(CMAKE_CXX_EXTENSIONS ${CMAKE_C_EXTENSIONS})

set(CMAKE_C_VISIBILITY_PRESET hidden)
set(CMAKE_CXX_VISIBILITY_PRESET ${CMAKE_C_VISIBILITY_PRESET})
set(CMAKE_VISIBILITY_INLINES_HIDDEN ON)

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib")
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin")
set(CMAKE_PDB_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin")

#string(APPEND CMAKE_C_FLAGS " -Wl,--as-needed -Wl,--no-undefined")
#string(APPEND CMAKE_CXX_FLAGS " -Wl,--as-needed -Wl,--no-undefined")

include(GNUInstallDirs)
include(Diagnostics)
include(Valgrind)
include(uninstall)
include(CTest)
if(BUILD_TESTING)
    #include(download/googletest)
    #include(download/benchmark)
    #include(download/Catch2)
endif()
#include(download/abseil-cpp)
#include(download/GSL)
include(Warnings)
include(format)
include(StaticChecks)
include(Sanitizers)
include(Coverage)
include(gcovr)
include(Profiling)
include(ProjectHelpers)

add_subdirectory(external)

add_subdirectory(src)

if(BUILD_TESTING)
    add_subdirectory(tests)
endif()

add_subdirectory(docs)
