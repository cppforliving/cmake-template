projname_add_library(examples)

projname_add_test(examples_test
  DEPENDS
    examples
    gtest_main
  EXTRA_ARGS
    --gtest_color=yes
)

add_subdirectory(capicpp)
add_subdirectory(containers)
add_subdirectory(cppapi)
add_subdirectory(derived)
add_subdirectory(finally)
add_subdirectory(parallel)
