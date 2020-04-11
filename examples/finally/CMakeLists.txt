projname_add_library(finally INTERFACE
  SOURCES
    finally.hpp
)

projname_add_test(finally_test
  SOURCES
    finally_test.cpp
  DEPENDS
    finally
    gtest_main
  EXTRA_ARGS
    --gtest_color=yes
)
