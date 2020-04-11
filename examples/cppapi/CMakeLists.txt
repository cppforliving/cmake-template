projname_add_library(cppapi
  SOURCES
    cppapi.cpp
    cppapi.hpp
)

projname_add_test(cppapi_test
  SOURCES
    cppapi_test.cpp
  DEPENDS
    cppapi
    gtest_main
  EXTRA_ARGS
    --gtest_color=yes
)
