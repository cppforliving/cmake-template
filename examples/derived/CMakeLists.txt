cmade_cxx_add_library(derived
  SOURCES
    derived.cpp
    derived.hpp
)

cmade_cxx_add_test(derived_test
  SOURCES
    derived_test.cpp
  DEPENDS
    derived
    gtest_main
  EXTRA_ARGS
    --gtest_color=yes
)
