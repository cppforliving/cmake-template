cmake_minimum_required(VERSION 3.5 FATAL_ERROR)
project(cmake-template)

option(BUILD_COVERAGE "Build for coverage analysis" OFF)
option(BUILD_PROFILING "Build for performance analysis" OFF)
set(VALGRIND_TOOL memcheck CACHE STRING "Valgrind tool")

list(APPEND CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/cmake")

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_EXTENSIONS OFF)
if(MSVC)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /W4 /WX")
else()
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wextra -Werror")
endif()

find_program(GCOVR_COMMAND gcovr)
if(GCOVR_COMMAND)
    add_custom_target(gcovr
        COMMAND ${GCOVR_COMMAND} --html --html-details
            -r ${PROJECT_SOURCE_DIR}
            -e ${PROJECT_SOURCE_DIR}/test 
            -e ${PROJECT_BINARY_DIR}
            --object-directory=${PROJECT_BINARY_DIR}
            -o ${PROJECT_BINARY_DIR}/coverage.html
        COMMENT "Generating gcovr html report")
endif()

set(VALGRIND_COMMAND_OPTIONS "-q --tool=${VALGRIND_TOOL}")
if(VALGRIND_TOOL STREQUAL memcheck)
    set(VALGRIND_COMMAND_OPTIONS "${VALGRIND_COMMAND_OPTIONS} --leak-check=yes --show-reachable=yes --num-callers=50 \
        --suppressions=${PROJECT_SOURCE_DIR}/valgrind.supp")
endif()

include(CTest)
if(BUILD_TESTING)
    include(googletest-download)
endif()

if(BUILD_COVERAGE)
    if(MSVC)
        message(FATAL_ERROR "BUILD_COVERAGE not supported yet for MSVC")
    else()
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} --coverage")
    endif()
endif()

if(BUILD_PROFILING)
    if(MSVC)
        message(FATAL_ERROR "BUILD_PROFILING not supported yet for MSVC")
    else()
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -pg")
    endif()
endif()

add_subdirectory(doc)
add_subdirectory(src)
if(BUILD_TESTING)
    add_subdirectory(test)
endif()
