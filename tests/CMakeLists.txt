add_custom_test(integration_test
  SOURCES
    projname_test.cpp
  DEPENDS
    ${PROJECT_NAME}
    catch2_main
  EXTRA_ARGS
    --use-colour=yes
)

add_test(
  NAME ${PROJECT_NAME}_tool_test
  COMMAND ${PROJECT_NAME}_tool
)
