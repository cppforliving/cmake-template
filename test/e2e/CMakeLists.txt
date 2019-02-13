set(TEST_NAME example_e2e_test)
set(SOURCE_FILES example_e2e_test.cpp)
add_executable(${TEST_NAME} ${SOURCE_FILES})
target_link_libraries(${TEST_NAME} catch_main Catch2::Catch2 example)
add_custom_command(TARGET ${TEST_NAME} POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E make_directory test-reports)
add_test(NAME ${TEST_NAME} COMMAND ${TEST_NAME}
    --use-colour=yes)
set_tests_properties(${TEST_NAME} PROPERTIES LABELS e2e)
