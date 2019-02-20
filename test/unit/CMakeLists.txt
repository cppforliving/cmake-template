set(TEST_NAME example_unit_test)
add_executable(${TEST_NAME}
    example_unit_test.cpp
    CoroutinesTS.cpp
)
target_link_libraries(${TEST_NAME}
    gtest::gtest
    example
)
debug_dynamic_depencencies(${TEST_NAME})
if(APPLE)
    set(TEST_ENV "DYLD_LIBRARY_PATH=${CMAKE_BINARY_DIR}/lib:$DYLD_LIBRARY_PATH")
elseif(UNIX)
    set(TEST_ENV "LD_LIBRARY_PATH=${CMAKE_BINARY_DIR}/lib:$LD_LIBRARY_PATH")
elseif(WIN32)
    set(TEST_ENV "PATH=${CMAKE_BINARY_DIR}/bin:$PATH")
endif()
add_test(${TEST_NAME} ${CMAKE_COMMAND} -E env ${TEST_ENV}
    ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${TEST_NAME}${CMAKE_EXECUTABLE_SUFFIX}
        --gtest_color=yes
        --gtest_output=xml:${TEST_NAME}.xml
)
