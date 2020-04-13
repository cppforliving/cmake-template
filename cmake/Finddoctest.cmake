include(FindPackageHandleStandardArgs)


find_path(doctest_INCLUDE_DIR
    NAMES doctest/doctest.h
    PATH_SUFFIXES include)

find_package_handle_standard_args(doctest
    FOUND_VAR doctest_FOUND
    REQUIRED_VARS doctest_INCLUDE_DIR)

if(doctest_FOUND)
    if(NOT TARGET doctest::doctest)
        add_library(doctest::doctest INTERFACE IMPORTED)
        target_include_directories(doctest::doctest
            INTERFACE ${doctest_INCLUDE_DIR})
    endif()

    set(doctest_INCLUDE_DIRS ${doctest_INCLUDE_DIR})
endif()

mark_as_advanced(doctest_INCLUDE_DIR)
