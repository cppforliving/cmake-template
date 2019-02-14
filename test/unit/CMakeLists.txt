set(TEST_NAME example_unit_test)
add_executable(${TEST_NAME}
    example_unit_test.cpp
    CoroutinesTS.cpp
)
target_link_libraries(${TEST_NAME}
    GTest::Main
    GTest::GTest
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
if(MSVC AND BUILD_SHARED_LIBS)
    target_compile_definitions(${TEST_NAME} PUBLIC -DGTEST_LINKED_AS_SHARED_LIBRARY=1)
endif()
add_test(NAME ${TEST_NAME} COMMAND ${TEST_NAME}
    --gtest_color=yes --gtest_output=xml:${TEST_NAME}.xml)
set_tests_properties(${TEST_NAME} PROPERTIES LABELS unit)
