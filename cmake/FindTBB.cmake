include(FindPackageHandleStandardArgs)


find_library(TBB_LIBRARY_RELEASE
    NAMES tbb
    PATH_SUFFIXES lib)

find_library(TBB_LIBRARY_DEBUG
    NAMES tbb_debug
    PATH_SUFFIXES lib)

find_path(TBB_INCLUDE_DIR
    NAMES tbb/tbb.h
    PATH_SUFFIXES include)

if(NOT CMAKE_BUILD_TYPE)
    set(required_tbb_libraries TBB_LIBRARY_RELEASE TBB_LIBRARY_DEBUG)
elseif(CMAKE_BUILD_TYPE MATCHES "^[Dd][Ee][Bb][Uu][Gg]$")
    set(required_tbb_libraries TBB_LIBRARY_DEBUG)
else()
    set(required_tbb_libraries TBB_LIBRARY_RELEASE)
endif()

find_package_handle_standard_args(TBB
    FOUND_VAR TBB_FOUND
    REQUIRED_VARS ${required_tbb_libraries} TBB_INCLUDE_DIR)

if(TBB_FOUND)
    if(NOT TARGET TBB::tbb)
        add_library(TBB::tbb INTERFACE IMPORTED)
        target_link_libraries(TBB::tbb
            INTERFACE
                optimized ${TBB_LIBRARY_RELEASE}
                debug ${TBB_LIBRARY_DEBUG})
        target_include_directories(TBB::tbb
            INTERFACE ${TBB_INCLUDE_DIR})
    endif()
endif()

mark_as_advanced(TBB_LIBRARY_RELEASE TBB_LIBRARY_DEBUG TBB_INCLUDE_DIR)
