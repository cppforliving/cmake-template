set(Python_FIND_REGISTRY NEVER)
find_package(Python MODULE REQUIRED
  COMPONENTS
    Interpreter
)
set_property(TARGET
    Python::Interpreter
  PROPERTY
    IMPORTED_GLOBAL TRUE
)
