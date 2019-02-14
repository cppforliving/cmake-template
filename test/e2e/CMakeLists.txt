set(TEST_NAME example_e2e_test)
add_executable(${TEST_NAME}
    example_e2e_test.cpp
)
target_link_libraries(${TEST_NAME}
    catch_main
    Catch2::Catch2
    example
)
if(APPLE)
    add_custom_command(TARGET ${TEST_NAME} POST_BUILD
        COMMAND otool -l ${TEST_NAME}
        COMMAND otool -L ${TEST_NAME})
elseif(NOT MSVC)
    add_custom_command(TARGET ${TEST_NAME} POST_BUILD
        COMMAND objdump -x ${TEST_NAME} | grep -i PATH
        COMMAND ldd ${TEST_NAME})
endif()
add_test(NAME ${TEST_NAME} COMMAND ${TEST_NAME}
    --use-colour=yes)
set_tests_properties(${TEST_NAME} PROPERTIES LABELS e2e)
