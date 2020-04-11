projname_add_test(integration_test
  SOURCES
    integration_test.cpp
  DEPENDS
    projname
    catch2_main
  EXTRA_ARGS
    --use-colour=yes
)

projname_add_pytest(test_pyprojname.py
  SOURCES
    test_pyprojname.py
  DEPENDS
    pyprojname
)

projname_add_pytest(test_projname_tool.py
  SOURCES
    test_projname_tool.py
  DEPENDS
    projname_tool
)
