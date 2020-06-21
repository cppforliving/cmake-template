target_sources(examples
  PUBLIC
    "$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/finally.hpp>"
)

target_sources(examples_test
  PRIVATE
    finally_test.cpp
)
