set(Boost_NO_SYSTEM_PATHS ON)
find_package(Boost MODULE REQUIRED 
  COMPONENTS
    system
    date_time
)
set_target_properties(
    Boost::system
    Boost::date_time
    Boost::diagnostic_definitions
    Boost::disable_autolinking
    Boost::dynamic_linking
  PROPERTIES
    IMPORTED_GLOBAL TRUE
)
