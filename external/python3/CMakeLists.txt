set(Python3_FIND_REGISTRY NEVER)
find_package(Python3 MODULE REQUIRED
  COMPONENTS
    Interpreter
)
set_property(TARGET
    Python3::Interpreter
  PROPERTY
    IMPORTED_GLOBAL TRUE
)
