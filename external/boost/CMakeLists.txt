set(Boost_NO_SYSTEM_PATHS ON)
find_package(Boost 1.71 EXACT MODULE REQUIRED
  COMPONENTS
    system
    date_time
)
set_target_properties(
    Boost::system
    Boost::date_time
    Boost::boost
    Boost::diagnostic_definitions
    Boost::disable_autolinking
    Boost::dynamic_linking
  PROPERTIES
    IMPORTED_GLOBAL TRUE
    INTERFACE_COMPILE_DEFINITIONS BOOST_ASIO_NO_DEPRECATED
    INTERFACE_COMPILE_DEFINITIONS BOOST_SYSTEM_NO_DEPRECATED
)

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
        set_target_properties(boost_throw_exception
          PROPERTIES
            POSITION_INDEPENDENT_CODE ON
        )
    endif()
endif()
