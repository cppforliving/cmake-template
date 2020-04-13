cmade_cxx_add_test(integration_test
  SOURCES
    integration_test.cpp
  DEPENDS
    projname
    catch2_main
  EXTRA_ARGS
    --use-colour=yes
)

cmade_py_add_test(test_pyprojname.py
  SOURCES
    test_pyprojname.py
  DEPENDS
    pyprojname
)

cmade_py_add_test(test_projname_tool.py
  SOURCES
    test_projname_tool.py
  DEPENDS
    projname_tool
)
