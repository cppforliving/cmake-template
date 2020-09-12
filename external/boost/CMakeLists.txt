find_package(Boost 1.73 REQUIRED COMPONENTS coroutine thread)
set(boost_tgts
    Boost::boost
    Boost::headers
    Boost::coroutine
    Boost::thread
)
projname_print_target_properties(${boost_tgts})
set_property(TARGET
    ${boost_tgts}
  PROPERTY
    IMPORTED_GLOBAL TRUE
)
