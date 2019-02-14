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
add_test(NAME ${TEST_NAME} COMMAND ${CMAKE_COMMAND} -E env
    $<$<BOOL:APPLE>:DYLD_LIBRARY_PATH=${CMAKE_BINARY_DIR}/lib:$DYLD_LIBRARY_PATH>
    $<$<BOOL:WIN32>:PATH=${CMAKE_BINARY_DIR}/bin:$PATH>
    ${TEST_NAME} --use-colour=yes)
