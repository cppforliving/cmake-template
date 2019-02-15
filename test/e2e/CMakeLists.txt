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
if(APPLE)
    set(TEST_ENV "DYLD_LIBRARY_PATH=${CMAKE_BINARY_DIR}/lib:$DYLD_LIBRARY_PATH")
elseif(UNIX)
    set(TEST_ENV "LD_LIBRARY_PATH=${CMAKE_BINARY_DIR}/lib:$LD_LIBRARY_PATH")
elseif(WIN32)
    set(TEST_ENV "PATH=${CMAKE_BINARY_DIR}/bin:$PATH")
endif()
add_test(${TEST_NAME} ${CMAKE_COMMAND} -E env ${TEST_ENV}
    ./${TEST_NAME} --use-colour=yes)
