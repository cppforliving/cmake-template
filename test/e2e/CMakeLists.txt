set(test_name e2e_test)
add_executable(${test_name})
target_sources(${test_name}
  PRIVATE
    clegacy_e2e_test.cpp
    example_e2e_test.cpp
)
target_link_libraries(${test_name}
  PRIVATE
    catch_main
    Catch2::Catch2
    clegacy
    example
)
debug_dynamic_dependencies(${test_name})
add_test(NAME ${test_name} COMMAND ${test_name}
    --use-colour=yes
)
