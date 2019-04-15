find_path(GSL_INCLUDE_DIRS NAMES gsl/gsl PATH_SUFFIXES include)
if(GSL_INCLUDE_DIRS)
    if(NOT TARGET GSL::GSL)
        add_library(GSL::GSL INTERFACE IMPORTED)
            set_target_properties(GSL::GSL PROPERTIES
                INTERFACE_INCLUDE_DIRECTORIES "${GSL_INCLUDE_DIRS}")
    endif()
endif()
