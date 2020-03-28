find_package(asio REQUIRED)
set_property(TARGET
    asio::asio
  PROPERTY
    IMPORTED_GLOBAL TRUE
)
set_property(TARGET
    asio::asio
  APPEND PROPERTY
    INTERFACE_COMPILE_DEFINITIONS
      #ASIO_NO_DEPRECATED
      $<$<TARGET_EXISTS:Boost::date_time>:ASIO_HAS_BOOST_DATE_TIME>
)
