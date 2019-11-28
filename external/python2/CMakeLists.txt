set(Python2_FIND_REGISTRY NEVER)
find_package(Python2 MODULE REQUIRED
  COMPONENTS
    Interpreter
)
set_property(TARGET
    Python2::Interpreter
  PROPERTY
    IMPORTED_GLOBAL TRUE
)
