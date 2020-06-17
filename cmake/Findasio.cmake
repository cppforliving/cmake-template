include(FindPackageHandleStandardArgs)


find_path(ASIO_INCLUDE_DIR
    NAMES asio.hpp
    PATH_SUFFIXES include)

find_package_handle_standard_args(asio
    FOUND_VAR ASIO_FOUND
    REQUIRED_VARS ASIO_INCLUDE_DIR)

if(ASIO_FOUND)
    if(NOT TARGET asio::asio)
        add_library(asio::asio INTERFACE IMPORTED)
        target_include_directories(asio::asio
            INTERFACE ${ASIO_INCLUDE_DIR})
        target_compile_definitions(asio::asio
            INTERFACE ASIO_STANDALONE)
    endif()

    set(ASIO_INCLUDE_DIRS ${ASIO_INCLUDE_DIR})
endif()

mark_as_advanced(ASIO_INCLUDE_DIR)
