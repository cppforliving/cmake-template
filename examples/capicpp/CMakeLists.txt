projname_add_library(capicpp
  SOURCES
    capicpp.cpp
    capicpp.h
)

projname_add_test(capicpp_test
  SOURCES
    capicpp_test.cpp
  DEPENDS
    capicpp
    gtest_main
  EXTRA_ARGS
    --gtest_color=yes
)
