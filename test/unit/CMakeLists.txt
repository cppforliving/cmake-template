set(test_name example_unit_test)
add_executable(${test_name}
    example_unit_test.cpp
)
target_link_libraries(${test_name}
    gtest::gtest
    example
)
debug_dynamic_depencencies(${test_name})
set(cfg_intdir $<IF:$<STREQUAL:.,${CMAKE_CFG_INTDIR}>,.,$<CONFIG>>)
if(APPLE)
    set(test_env "DYLD_LIBRARY_PATH=${CMAKE_BINARY_DIR}/lib:${CMAKE_BINARY_DIR}/lib/${cfg_intdir}:$DYLD_LIBRARY_PATH")
elseif(UNIX)
    set(test_env "LD_LIBRARY_PATH=${CMAKE_BINARY_DIR}/lib:${CMAKE_BINARY_DIR}/lib/${cfg_intdir}:$LD_LIBRARY_PATH")
elseif(WIN32)
    file(TO_NATIVE_PATH "${CMAKE_BINARY_DIR}" native_cmake_binary_dir)
    set(test_env "PATH=${native_cmake_binary_dir}\\bin\;${native_cmake_binary_dir}\\bin\\${cfg_intdir}\;%PATH%")
endif()
add_test(NAME ${test_name} COMMAND ${CMAKE_COMMAND} -E env ${test_env}
    ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${cfg_intdir}/${test_name}${CMAKE_EXECUTABLE_SUFFIX}
        --gtest_color=yes
        --gtest_output=xml:${test_name}.xml
)
