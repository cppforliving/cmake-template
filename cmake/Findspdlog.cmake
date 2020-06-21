include(CMakeFindDependencyMacro)
include(FindPackageHandleStandardArgs)

find_package(Threads REQUIRED)
find_dependency(fmt MODULE)

set(SPDLOG_FMT_EXTERNAL ON)

find_library(spdlog_LIBRARY_RELEASE
    NAMES spdlog
    PATH_SUFFIXES lib)

find_library(spdlog_LIBRARY_DEBUG
    NAMES spdlogd
    PATH_SUFFIXES lib)

find_path(spdlog_INCLUDE_DIR
    NAMES spdlog/spdlog.h
    PATH_SUFFIXES include)

if(NOT CMAKE_BUILD_TYPE)
    set(required_spdlog_library_names spdlog_LIBRARY_RELEASE spdlog_LIBRARY_DEBUG)
elseif(CMAKE_BUILD_TYPE MATCHES "^[Dd][Ee][Bb][Uu][Gg]$")
    set(required_spdlog_library_names spdlog_LIBRARY_DEBUG)
else()
    set(required_spdlog_library_names spdlog_LIBRARY_RELEASE)
endif()

find_package_handle_standard_args(spdlog
    FOUND_VAR spdlog_FOUND
    REQUIRED_VARS ${required_spdlog_library_names} spdlog_INCLUDE_DIR)

if(spdlog_FOUND)
    if(NOT TARGET spdlog::spdlog
        AND (spdlog_LIBRARY_RELEASE OR spdlog_LIBRARY_DEBUG))
        add_library(spdlog::spdlog SHARED IMPORTED)
        target_link_libraries(spdlog::spdlog
            INTERFACE Threads::Threads fmt::fmt)
        target_include_directories(spdlog::spdlog
            INTERFACE ${spdlog_INCLUDE_DIR})
        target_compile_definitions(spdlog::spdlog
            INTERFACE SPDLOG_COMPILED_LIB SPDLOG_FMT_EXTERNAL)
        if(spdlog_LIBRARY_RELEASE)
            set_property(TARGET spdlog::spdlog
                APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE
            )
            set_target_properties(spdlog::spdlog PROPERTIES
                IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "CXX"
                IMPORTED_LOCATION_RELEASE "${spdlog_LIBRARY_RELEASE}"
            )
        endif()
        if(spdlog_LIBRARY_DEBUG)
            set_property(TARGET spdlog::spdlog
                APPEND PROPERTY IMPORTED_CONFIGURATIONS DEBUG
            )
            set_target_properties(spdlog::spdlog PROPERTIES
                IMPORTED_LINK_INTERFACE_LANGUAGES_DEBUG "CXX"
                IMPORTED_LOCATION_DEBUG "${spdlog_LIBRARY_DEBUG}"
            )
        endif()
    endif()

    if(NOT TARGET spdlog::spdlog_header_only)
        add_library(spdlog::spdlog_header_only INTERFACE IMPORTED)
        target_link_libraries(spdlog::spdlog_header_only
            INTERFACE Threads::Threads fmt::fmt)
        target_include_directories(spdlog::spdlog_header_only
            INTERFACE ${spdlog_INCLUDE_DIR})
        target_compile_definitions(spdlog::spdlog_header_only
            INTERFACE SPDLOG_FMT_EXTERNAL)
    endif()
endif()

mark_as_advanced(spdlog_LIBRARY_RELEASE spdlog_LIBRARY_DEBUG spdlog_INCLUDE_DIR)
