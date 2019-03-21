set(test_name unit_test)
add_executable(${test_name})
target_sources(${test_name}
  PRIVATE
    example_unit_test.cpp
)
target_link_libraries(${test_name}
  PRIVATE
    GTest::Main
    GTest::GTest
    example
)
debug_dynamic_dependencies(${test_name})
add_test(NAME ${test_name} COMMAND ${test_name}
    --gtest_color=yes
    --gtest_output=xml:${test_name}.xml
)
