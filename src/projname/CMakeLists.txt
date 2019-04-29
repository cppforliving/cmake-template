add_library(${PROJECT_NAME}_obj OBJECT)
target_sources(${PROJECT_NAME}_obj
  PRIVATE
    projname.cpp
    projname.hpp
)
target_link_libraries(${PROJECT_NAME}_obj
  PUBLIC
    clegacy
    example
    Threads::Threads
    Boost::system
    Boost::date_time
    Boost::diagnostic_definitions
    Boost::disable_autolinking
    Boost::dynamic_linking
    GSL::GSL
)
if(MSVC)
    target_compile_definitions(${PROJECT_NAME}_obj
      PRIVATE
        $<$<COMPILE_LANGUAGE:CXX>:_SILENCE_CXX17_ITERATOR_BASE_CLASS_DEPRECATION_WARNING>
    )
endif()

add_executable(${PROJECT_NAME})
target_sources(${PROJECT_NAME}
  PRIVATE
    projname_main.cpp
)
target_link_libraries(${PROJECT_NAME}
  PRIVATE
    ${PROJECT_NAME}_obj
)
debug_dynamic_dependencies(${PROJECT_NAME})
install(TARGETS ${PROJECT_NAME}
    EXPORT ${PROJECT_NAME}
    DESTINATION "${CMAKE_INSTALL_BINDIR}")

if(BUILD_TESTING)
    add_gtest_test(${PROJECT_NAME}_test
      SOURCES
        projname_test.cpp
      DEPENDS
        ${PROJECT_NAME}_obj
    )
endif()
