projname_add_test(integration_test
  SOURCES
    integration_test.cpp
  DEPENDS
    ${PROJECT_NAME}
    catch2_main
  EXTRA_ARGS
    --use-colour=yes
)

projname_add_pytest(test_pyprojname.py
  SOURCES
    test_pyprojname.py
  DEPENDS
    py${PROJECT_NAME}
)

projname_add_pytest(test_${PROJECT_NAME}_tool.py
  SOURCES
    test_projname_tool.py
  DEPENDS
    ${PROJECT_NAME}_tool
)
