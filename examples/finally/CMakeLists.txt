cmade_cxx_add_library(finally INTERFACE
  SOURCES
    finally.hpp
)

cmade_cxx_add_test(finally_test
  SOURCES
    finally_test.cpp
  DEPENDS
    finally
    gtest_main
  EXTRA_ARGS
    --gtest_color=yes
)
