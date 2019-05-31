find_path(GSL_INCLUDE_DIRS
  NAMES
    gsl/gsl
)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(GSL
  REQUIRED_VARS
    GSL_INCLUDE_DIRS
  VERSION_VAR
    GSL_VERSION
)

if(GSL_FOUND AND NOT TARGET GSL::gsl)
    add_library(GSL::gsl INTERFACE IMPORTED)
    set_target_properties(
        GSL::gsl
      PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES "${GSL_INCLUDE_DIRS}"
    )
endif()
