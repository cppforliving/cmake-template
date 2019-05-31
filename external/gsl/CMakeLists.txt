find_package(GSL MODULE REQUIRED)
set_target_properties(
    GSL::gsl
  PROPERTIES
    IMPORTED_GLOBAL TRUE
)
