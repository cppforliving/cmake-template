set(Boost_NO_SYSTEM_PATHS ON)
set(Boost_NO_BOOST_CMAKE ON)
find_package(Boost MODULE REQUIRED
  COMPONENTS
    system
    date_time
)
set(boost_targets
    Boost::system
    Boost::date_time
    Boost::boost
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
      #BOOST_SYSTEM_NO_DEPRECATED
)
unset(boost_targets)
