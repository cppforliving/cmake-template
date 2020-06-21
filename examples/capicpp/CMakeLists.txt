target_sources(examples
  PRIVATE
    capicpp.cpp
  PUBLIC
    "$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/capicpp.h>"
)

target_sources(examples_test
  PRIVATE
    capicpp_test.cpp
)
