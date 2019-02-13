# Source https://github.com/google/googletest/blob/master/googletest/README.md#incorporating-into-an-existing-cmake-project

# Download and unpack abseil-cpp at configure time

set(_git_parent https://github.com/abseil)
set(_git_name   abseil-cpp)
set(_git_tag    20180600)
configure_file("${CMAKE_CURRENT_LIST_DIR}/CMakeLists.txt.in"
               "${CMAKE_BINARY_DIR}/abseil-cpp-download/CMakeLists.txt"
               @ONLY)

execute_process(COMMAND ${CMAKE_COMMAND} -G "${CMAKE_GENERATOR}" .
    RESULT_VARIABLE result
    WORKING_DIRECTORY "${CMAKE_BINARY_DIR}/abseil-cpp-download")
if(result)
    message(FATAL_ERROR "CMake step for abseil-cpp failed: ${result}")
endif()

execute_process(COMMAND ${CMAKE_COMMAND} --build .
    RESULT_VARIABLE result
    WORKING_DIRECTORY "${CMAKE_BINARY_DIR}/abseil-cpp-download")
if(result)
    message(FATAL_ERROR "Build step for abseil-cpp failed: ${result}")
endif()

# Add abseil-cpp directly to our build. This defines
# the absl_* targets.
add_subdirectory("${CMAKE_BINARY_DIR}/abseil-cpp-src"
                 "${CMAKE_BINARY_DIR}/abseil-cpp-build"
                 EXCLUDE_FROM_ALL)
