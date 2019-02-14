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
debug_dynamic_depencencies(${TEST_NAME})
if(MSVC AND BUILD_SHARED_LIBS)
    target_compile_definitions(${TEST_NAME} PUBLIC -DGTEST_LINKED_AS_SHARED_LIBRARY=1)
endif()
add_test(NAME ${TEST_NAME} COMMAND ${CMAKE_COMMAND} -E env
    $<$<BOOL:APPLE>:DYLD_LIBRARY_PATH=${CMAKE_BINARY_DIR}/lib:$DYLD_LIBRARY_PATH>
    $<$<BOOL:WIN32>:PATH=${CMAKE_BINARY_DIR}/bin:$PATH>
    ${TEST_NAME} --gtest_color=yes --gtest_output=xml:${TEST_NAME}.xml)
