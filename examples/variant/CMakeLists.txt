projname_add_test(variant_test
  SOURCES
    variant_test.cpp
  DEPENDS
    gtest_main
  EXTRA_ARGS
    --gtest_color=yes
)
