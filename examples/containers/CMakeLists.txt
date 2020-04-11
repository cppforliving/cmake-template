projname_add_library(containers INTERFACE
  SOURCES
    remove_duplicates.hpp
    ssize.hpp
)

projname_add_test(containers_test
  SOURCES
    remove_duplicates_test.cpp
    ssize_test.cpp
  DEPENDS
    containers
    gtest_main
  EXTRA_ARGS
    --gtest_color=yes
)
