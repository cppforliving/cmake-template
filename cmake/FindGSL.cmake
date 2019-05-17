find_path(GSL_INCLUDE_DIRS
  NAMES
    gsl/gsl
  PATH_SUFFIXES
    include
)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(GSL
  REQUIRED_VARS
    GSL_INCLUDE_DIRS
  VERSION_VAR
    GSL_VERSION
)

if(GSL_INCLUDE_DIRS)
    if(NOT TARGET GSL::GSL)
        add_library(GSL::GSL INTERFACE IMPORTED)
        set_target_properties(
            GSL::GSL
          PROPERTIES
            INTERFACE_INCLUDE_DIRECTORIES "${GSL_INCLUDE_DIRS}"
        )
    endif()
endif()
