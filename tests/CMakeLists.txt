projname_add_test(integration_catch2_test
  SOURCES
    integration_catch2_test.cpp
  DEPENDS
    projname
    catch2_main
  EXTRA_ARGS
    --use-colour=yes
)

projname_add_test(integration_doctest_test
  SOURCES
    integration_doctest_test.cpp
  DEPENDS
    projname
    doctest_main
  EXTRA_ARGS
    --force-colors=true
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
