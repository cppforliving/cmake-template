include(FindPackageHandleStandardArgs)


find_path(Catch2_INCLUDE_DIR
    NAMES catch2/catch.hpp
    PATH_SUFFIXES include)

find_package_handle_standard_args(Catch2
    FOUND_VAR Catch2_FOUND
    REQUIRED_VARS Catch2_INCLUDE_DIR)

if(Catch2_FOUND)
    if(NOT TARGET Catch2::Catch2)
        add_library(Catch2::Catch2 INTERFACE IMPORTED)
        target_include_directories(Catch2::Catch2
            INTERFACE ${Catch2_INCLUDE_DIR})
    endif()

    set(Catch2_INCLUDE_DIRS ${Catch2_INCLUDE_DIR})
endif()

mark_as_advanced(Catch2_INCLUDE_DIR)
