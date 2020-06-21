include(FindPackageHandleStandardArgs)


find_library(fmt_LIBRARY_RELEASE
    NAMES fmt
    PATH_SUFFIXES lib)

find_library(fmt_LIBRARY_DEBUG
    NAMES fmtd
    PATH_SUFFIXES lib)

find_path(fmt_INCLUDE_DIR
    NAMES fmt/format.h
    PATH_SUFFIXES include)

if(NOT CMAKE_BUILD_TYPE)
    set(required_fmt_library_names fmt_LIBRARY_RELEASE fmt_LIBRARY_DEBUG)
elseif(CMAKE_BUILD_TYPE MATCHES "^[Dd][Ee][Bb][Uu][Gg]$")
    set(required_fmt_library_names fmt_LIBRARY_DEBUG)
else()
    set(required_fmt_library_names fmt_LIBRARY_RELEASE)
endif()

find_package_handle_standard_args(fmt
    FOUND_VAR fmt_FOUND
    REQUIRED_VARS ${required_fmt_library_names} fmt_INCLUDE_DIR)

if(fmt_FOUND)
    if(NOT TARGET fmt::fmt
        AND (fmt_LIBRARY_RELEASE OR fmt_LIBRARY_DEBUG))
        add_library(fmt::fmt SHARED IMPORTED)
        target_link_libraries(fmt::fmt
            INTERFACE ${fmt_LIBRARY})
        target_include_directories(fmt::fmt
            INTERFACE ${fmt_INCLUDE_DIR})
        if(fmt_LIBRARY_RELEASE)
            set_property(TARGET fmt::fmt
                APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE
            )
            set_target_properties(fmt::fmt PROPERTIES
                IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "CXX"
                IMPORTED_LOCATION_RELEASE "${fmt_LIBRARY_RELEASE}"
            )
        endif()
        if(fmt_LIBRARY_DEBUG)
            set_property(TARGET fmt::fmt
                APPEND PROPERTY IMPORTED_CONFIGURATIONS DEBUG
            )
            set_target_properties(fmt::fmt PROPERTIES
                IMPORTED_LINK_INTERFACE_LANGUAGES_DEBUG "CXX"
                IMPORTED_LOCATION_DEBUG "${fmt_LIBRARY_DEBUG}"
            )
        endif()
    endif()
endif()

mark_as_advanced(fmt_LIBRARY fmt_INCLUDE_DIR)
