# Source https://github.com/google/googletest/blob/master/googletest/README.md#incorporating-into-an-existing-cmake-project

# Download and unpack benchmark at configure time

set(_git_parent https://github.com/google)
set(_git_name   benchmark)
set(_git_tag    v1.4.1)
configure_file("${CMAKE_CURRENT_LIST_DIR}/CMakeLists.txt.in"
               "${CMAKE_BINARY_DIR}/benchmark-download/CMakeLists.txt"
               @ONLY)

execute_process(COMMAND ${CMAKE_COMMAND} -G "${CMAKE_GENERATOR}" .
    RESULT_VARIABLE result
    WORKING_DIRECTORY "${CMAKE_BINARY_DIR}/benchmark-download")
if(result)
    message(FATAL_ERROR "CMake step for benchmark failed: ${result}")
endif()

execute_process(COMMAND ${CMAKE_COMMAND} --build .
    RESULT_VARIABLE result
    WORKING_DIRECTORY "${CMAKE_BINARY_DIR}/benchmark-download")
if(result)
    message(FATAL_ERROR "Build step for benchmark failed: ${result}")
endif()

# Add benchmark directly to our build. This defines
# the benchmark targets.
add_subdirectory("${CMAKE_BINARY_DIR}/benchmark-src"
                 "${CMAKE_BINARY_DIR}/benchmark-build"
                 EXCLUDE_FROM_ALL)
