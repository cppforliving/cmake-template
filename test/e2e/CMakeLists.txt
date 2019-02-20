set(test_name example_e2e_test)
add_executable(${test_name}
    example_e2e_test.cpp
)
target_link_libraries(${test_name}
    catch_main
    Catch2::Catch2
    example
)
debug_dynamic_depencencies(${test_name})
if(APPLE)
    set(test_env "DYLD_LIBRARY_PATH=${CMAKE_BINARY_DIR}/lib:$DYLD_LIBRARY_PATH")
elseif(UNIX)
    set(test_env "LD_LIBRARY_PATH=${CMAKE_BINARY_DIR}/lib:$LD_LIBRARY_PATH")
elseif(WIN32)
    set(test_env "PATH=${CMAKE_BINARY_DIR}/bin:$PATH")
endif()
add_test(NAME ${test_name} COMMAND ${CMAKE_COMMAND} -E env ${test_env}
    ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/$<IF:$<STREQUAL:.,${CMAKE_CFG_INTDIR}>,.,$<CONFIG>>/${test_name}${CMAKE_EXECUTABLE_SUFFIX}
        --use-colour=yes
)
