# Source https://github.com/google/googletest/blob/master/googletest/README.md#incorporating-into-an-existing-cmake-project

# Download and unpack GSL at configure time

set(_git_parent https://github.com/Microsoft)
set(_git_name   GSL)
set(_git_tag    v2.0.0)
configure_file("${CMAKE_CURRENT_LIST_DIR}/CMakeLists.txt.in"
               "${CMAKE_BINARY_DIR}/GSL-download/CMakeLists.txt"
               @ONLY)

execute_process(COMMAND ${CMAKE_COMMAND} -G "${CMAKE_GENERATOR}" .
    RESULT_VARIABLE result
    WORKING_DIRECTORY "${CMAKE_BINARY_DIR}/GSL-download")
if(result)
    message(FATAL_ERROR "CMake step for GSL failed: ${result}")
endif()

execute_process(COMMAND ${CMAKE_COMMAND} --build .
    RESULT_VARIABLE result
    WORKING_DIRECTORY "${CMAKE_BINARY_DIR}/GSL-download")
if(result)
    message(FATAL_ERROR "Build step for GSL failed: ${result}")
endif()

# Add GSL directly to our build. This defines
# the GSL targets.
add_subdirectory("${CMAKE_BINARY_DIR}/GSL-src"
                 "${CMAKE_BINARY_DIR}/GSL-build"
                 EXCLUDE_FROM_ALL)
