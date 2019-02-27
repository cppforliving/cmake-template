set(test_name unit_test)
add_executable(${test_name}
    example_unit_test.cpp
)
target_link_libraries(${test_name}
    gtest::gtest
    example
)
debug_dynamic_dependencies(${test_name})
add_test(NAME ${test_name} COMMAND ${test_name}
        --gtest_color=yes
        --gtest_output=xml:${test_name}.xml
)
