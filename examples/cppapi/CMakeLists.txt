target_sources(examples
  PRIVATE
    cppapi.cpp
  PUBLIC
    "$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/cppapi.hpp>"
)

target_sources(examples_test
  PRIVATE
    cppapi_test.cpp
)
