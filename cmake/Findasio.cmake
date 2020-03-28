find_path(ASIO_INCLUDE_DIR
    NAMES asio.hpp
    PATH_SUFFIXES include
)
if(ASIO_INCLUDE_DIR)
    message(STATUS "Found asio: ${ASIO_INCLUDE_DIR}")
    if(NOT TARGET asio::asio)
        add_library(asio::asio INTERFACE IMPORTED)
        target_include_directories(asio::asio
          INTERFACE
            "${ASIO_INCLUDE_DIR}"
        )
    endif()
else()
    message(FATAL_ERROR "Cannot find asio")
endif()
