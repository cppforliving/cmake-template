set(TEST_NAME example_e2e_test)
add_executable(${TEST_NAME}
    example_e2e_test.cpp
)
target_link_libraries(${TEST_NAME}
    catch_main
    Catch2::Catch2
    example
)
debug_dynamic_depencencies(${TEST_NAME})
add_test(NAME ${TEST_NAME} COMMAND ${TEST_NAME}
    --use-colour=yes)
set_tests_properties(${TEST_NAME} PROPERTIES LABELS e2e)
