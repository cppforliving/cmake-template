find_package(GSL MODULE REQUIRED)
set_target_properties(
    GSL::GSL
  PROPERTIES
    IMPORTED_GLOBAL TRUE
)
