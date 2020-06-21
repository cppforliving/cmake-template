target_sources(examples
  PRIVATE
    derived.cpp
  PUBLIC
    "$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/derived.hpp>"
)

target_sources(examples_test
  PRIVATE
    derived_test.cpp
)
