add_custom_test(integration_test
  SOURCES
    projname_test.cpp
  DEPENDS
    ${PROJECT_NAME}
    catch2_main
  EXTRA_ARGS
    --use-colour=yes
)

string(REPLACE "${PROJECT_SOURCE_DIR}/" "" full_test_name
    "${CMAKE_CURRENT_SOURCE_DIR}/${PROJECT_NAME}_tool_test"
)
add_test(NAME ${full_test_name}
    COMMAND ${PROJECT_NAME}_tool
)
