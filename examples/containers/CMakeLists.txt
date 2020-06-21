target_sources(examples
  PUBLIC
    "$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/remove_duplicates.hpp>"
    "$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/ssize.hpp>"
)

target_sources(examples_test
  PRIVATE
    remove_duplicates_test.cpp
    ssize_test.cpp
)
