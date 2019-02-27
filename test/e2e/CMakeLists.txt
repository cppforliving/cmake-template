set(test_name e2e_test)
add_executable(${test_name}
    clegacy_e2e_test.cpp
    example_e2e_test.cpp
)
target_link_libraries(${test_name}
    catch_main
    Catch2::Catch2
    clegacy
    example
)
debug_dynamic_dependencies(${test_name})
set(cfg_intdir $<IF:$<STREQUAL:.,${CMAKE_CFG_INTDIR}>,.,$<CONFIG>>)
if(APPLE)
    set(test_runner ${CMAKE_COMMAND} -E env DYLD_LIBRARY_PATH=${CMAKE_BINARY_DIR}/lib:${CMAKE_BINARY_DIR}/lib/${cfg_intdir}:$DYLD_LIBRARY_PATH)
elseif(UNIX)
    set(test_runner)
elseif(WIN32)
    file(TO_NATIVE_PATH "${CMAKE_BINARY_DIR}" native_cmake_binary_dir)
    set(test_runner ${CMAKE_COMMAND} -E env PATH=${native_cmake_binary_dir}\\bin\;${native_cmake_binary_dir}\\bin\\${cfg_intdir}\;%PATH%)
endif()
add_test(NAME ${test_name} COMMAND ${test_runner}
    ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${cfg_intdir}/${test_name}${CMAKE_EXECUTABLE_SUFFIX}
        --use-colour=yes
)
