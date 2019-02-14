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
add_test(${TEST_NAME} ${CMAKE_COMMAND} -E env
    $<$<PLATFORM_ID:Windows>:PATH=${CMAKE_BINARY_DIR}/bin:$PATH>
    $<$<PLATFORM_ID:Linux>:LD_LIBRARY_PATH=${CMAKE_BINARY_DIR}/lib:$LD_LIBRARY_PATH>
    $<$<PLATFORM_ID:Darwin>:DYLD_LIBRARY_PATH=${CMAKE_BINARY_DIR}/lib:$DYLD_LIBRARY_PATH>
    ./${TEST_NAME} --use-colour=yes)
