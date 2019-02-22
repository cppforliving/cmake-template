cmake_minimum_required(VERSION 3.10)
option(BUILD_SHARED_LIBS
    "Global flag to cause `add_library()` to create shared libraries if on." ON)
option(CMAKE_EXPORT_COMPILE_COMMANDS
    "Enable/Disable output of compile commands during generation." ON)
set(CMAKE_INSTALL_PREFIX "${CMAKE_BINARY_DIR}" CACHE STRING
    "Install path prefix, prepended onto install directories.")
option(CMAKE_INTERPROCEDURAL_OPTIMIZATION
    "Enable interprocedural optimization if supported by the compiler." OFF)
project(cmake-template)

list(APPEND CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/cmake")
include("${CMAKE_BINARY_DIR}/conan_paths.cmake")
list(INSERT CMAKE_MODULE_PATH 0 "${CMAKE_BINARY_DIR}")

set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS OFF)
set(CMAKE_C_VISIBILITY_PRESET hidden)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ${CMAKE_C_STANDARD_REQUIRED})
set(CMAKE_CXX_EXTENSIONS ${CMAKE_C_EXTENSIONS})
set(CMAKE_CXX_VISIBILITY_PRESET ${CMAKE_C_VISIBILITY_PRESET})

set(CMAKE_VISIBILITY_INLINES_HIDDEN ON)

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib")
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin")
set(CMAKE_PDB_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin")

string(APPEND CMAKE_C_FLAGS " -Wl,--as-needed")# -Wl,--no-undefined")
string(APPEND CMAKE_CXX_FLAGS " -Wl,--as-needed")# -Wl,--no-undefined")

find_package(Threads REQUIRED)
set(Boost_NO_SYSTEM_PATHS ON)
find_package(boost REQUIRED COMPONENTS system)
#find_package(Git REQUIRED)

include(GNUInstallDirs)
include(build/ColorDiagnostics)
include(build/CoroutinesTS)
include(build/ThreadSafety)
include(Valgrind)
include(uninstall)
include(CTest)
if(BUILD_TESTING)
    find_package(gtest REQUIRED)
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

function(debug_dynamic_depencencies target_name)
    set(target_file $<TARGET_FILE:${target_name}>)
    if(APPLE)
        add_custom_command(TARGET ${target_name} POST_BUILD
            COMMAND otool -l ${target_file} | grep PATH -A2
            COMMAND otool -L ${target_file})
    elseif(UNIX)
        add_custom_command(TARGET ${target_name} POST_BUILD
            COMMAND objdump -p ${target_file} | grep PATH
            COMMAND ldd ${target_file})
    elseif(WIN32)
        add_custom_command(TARGET ${target_name} POST_BUILD
            COMMAND dumpbin -DEPENDENTS ${target_file})
    endif()
endfunction()

add_subdirectory(doc)
add_subdirectory(src)
if(BUILD_TESTING)
    add_subdirectory(test)
endif()
