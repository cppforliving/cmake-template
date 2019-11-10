set(Boost_NO_SYSTEM_PATHS ON)
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
      BOOST_ASIO_NO_DEPRECATED
      BOOST_SYSTEM_NO_DEPRECATED
)
unset(boost_targets)

if(${PROJECT_NAME}_coverage)
    add_library(boost_throw_exception OBJECT)
    target_sources(boost_throw_exception
      PRIVATE
        boost_throw_exception.cpp
    )
    target_link_libraries(boost_throw_exception
      PRIVATE
        Boost::boost
    )
    if(BUILD_SHARED_LIBS)
        set_property(TARGET boost_throw_exception
          PROPERTY
            POSITION_INDEPENDENT_CODE ON
        )
    endif()
endif()
