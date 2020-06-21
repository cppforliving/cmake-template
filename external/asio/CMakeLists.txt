find_package(asio REQUIRED)
projname_print_target_properties(asio::asio)
set_property(TARGET
    asio::asio
  PROPERTY
    IMPORTED_GLOBAL TRUE
)
set_property(TARGET
    asio::asio
  APPEND PROPERTY
    INTERFACE_COMPILE_DEFINITIONS
      ASIO_NO_DEPRECATED
)
