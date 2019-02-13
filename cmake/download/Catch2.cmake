# Source https://github.com/google/googletest/blob/master/googletest/README.md#incorporating-into-an-existing-cmake-project

# Download and unpack googletest at configure time

set(_git_parent https://github.com/catchorg)
set(_git_name   Catch2)
set(_git_tag    v2.4.2)
configure_file("${CMAKE_CURRENT_LIST_DIR}/CMakeLists.txt.in"
               "${CMAKE_BINARY_DIR}/Catch2-download/CMakeLists.txt"
               @ONLY)

execute_process(COMMAND ${CMAKE_COMMAND} -G "${CMAKE_GENERATOR}" .
    RESULT_VARIABLE result
    WORKING_DIRECTORY "${CMAKE_BINARY_DIR}/Catch2-download")
if(result)
    message(FATAL_ERROR "CMake step for Catch2 failed: ${result}")
endif()

execute_process(COMMAND ${CMAKE_COMMAND} --build .
    RESULT_VARIABLE result
    WORKING_DIRECTORY "${CMAKE_BINARY_DIR}/Catch2-download")
if(result)
    message(FATAL_ERROR "Build step for Catch2 failed: ${result}")
endif()

# Add Catch2 directly to our build. This defines
# the Catch2 targets.
add_subdirectory("${CMAKE_BINARY_DIR}/Catch2-src"
                 "${CMAKE_BINARY_DIR}/Catch2-build"
                 EXCLUDE_FROM_ALL)
