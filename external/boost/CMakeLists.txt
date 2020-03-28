set(Boost_NO_SYSTEM_PATHS ON)
set(Boost_NO_BOOST_CMAKE ON)
set(Boost_ADDITIONAL_VERSIONS 1.72.0)
find_package(Boost MODULE REQUIRED
  COMPONENTS
    date_time
)
set(boost_targets
    Boost::headers
    Boost::date_time
    Boost::diagnostic_definitions
    Boost::disable_autolinking
    Boost::dynamic_linking
)
set_property(TARGET
    ${boost_targets}
  PROPERTY
    IMPORTED_GLOBAL TRUE
)
set_property(TARGET
    ${boost_targets}
  APPEND PROPERTY
    INTERFACE_COMPILE_DEFINITIONS
      #BOOST_ASIO_NO_DEPRECATED
)
unset(boost_targets)
