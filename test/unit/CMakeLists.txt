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
if(WIN32)
    set(TEST_ENV "PATH=${CMAKE_BINARY_DIR}/bin:$PATH")
elseif(APPLE)
    set(TEST_ENV "DYLD_LIBRARY_PATH=${CMAKE_BINARY_DIR}/lib:$DYLD_LIBRARY_PATH")
elseif(UNIX)
    set(TEST_ENV "LD_LIBRARY_PATH=${CMAKE_BINARY_DIR}/lib:$LD_LIBRARY_PATH")
endif()
add_test(${TEST_NAME} ${CMAKE_COMMAND} -E env ${TEST_ENV}
    ./${TEST_NAME} --gtest_color=yes --gtest_output=xml:${TEST_NAME}.xml)
