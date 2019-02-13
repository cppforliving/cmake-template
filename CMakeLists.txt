cmake_minimum_required(VERSION 3.10)
option(BUILD_SHARED_LIBS
    "Global flag to cause `add_library()` to create shared libraries if on." ON)
set(CMAKE_BUILD_TYPE Debug CACHE STRING
    "Choose the type of build, options are: None Debug Release RelWithDebInfo MinSizeRel.")
option(CMAKE_EXPORT_COMPILE_COMMANDS
    "Enable/Disable output of compile commands during generation." ON)
set(CMAKE_INSTALL_PREFIX "${CMAKE_BINARY_DIR}" CACHE STRING
    "Install path prefix, prepended onto install directories.")
option(CMAKE_INTERPROCEDURAL_OPTIMIZATION
    "If set to true, enables interprocedural optimizations if they are known to be supported." OFF)
project(cmake-template)

list(APPEND CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/cmake")
include("${CMAKE_BINARY_DIR}/conan_paths.cmake")

set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS OFF)
set(CMAKE_C_VISIBILITY_PRESET hidden)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ${CMAKE_C_STANDARD_REQUIRED})
set(CMAKE_CXX_EXTENSIONS ${CMAKE_C_EXTENSIONS})
set(CMAKE_CXX_VISIBILITY_PRESET ${CMAKE_C_VISIBILITY_PRESET})

set(CMAKE_VISIBILITY_INLINES_HIDDEN ON)

find_package(Threads)
set(Boost_NO_SYSTEM_PATHS ON)
find_package(Boost REQUIRED COMPONENTS system)
#find_package(Git REQUIRED)

include(GNUInstallDirs)
include(build/ColorDiagnostics)
include(build/CoroutinesTS)
include(build/ThreadSafety)
include(Valgrind)
include(uninstall)
include(CTest)
if(BUILD_TESTING)
    find_package(GTest REQUIRED)
    find_package(Catch2 REQUIRED)
    #include(download/googletest)
    #include(download/benchmark)
    #include(download/Catch2)
endif()
#include(download/abseil-cpp)
#include(download/GSL)
include(build/Warnings)
include(clang-format)
include(build/StaticChecks)
include(build/Sanitizer)
include(build/Coverage)
include(gcovr)
include(build/Profiling)

#set(CMAKE_INSTALL_RPATH ${CMAKE_INSTALL_FULL_LIBDIR} ${Boost_LIBRARY_DIRS})

add_subdirectory(doc)
add_subdirectory(src)
if(BUILD_TESTING)
    add_subdirectory(test)
endif()
