add_library(${PROJECT_NAME}_obj OBJECT)
target_sources(${PROJECT_NAME}_obj
  PRIVATE
    projname.cpp
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
)
target_include_directories(${PROJECT_NAME}_obj
  PUBLIC
    ${GSL_INCLUDE_DIRS}
)

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
    set(test_name ${PROJECT_NAME}_test)
    add_executable(${test_name})
    target_sources(${test_name}
      PRIVATE
        projname_test.cpp
    )
    target_link_libraries(${test_name}
      PRIVATE
        GTest::Main
        GTest::GTest
        ${PROJECT_NAME}_obj
    )
    target_compile_definitions(${test_name}
      PRIVATE
        GTEST_LINKED_AS_SHARED_LIBRARY=1
    )
    debug_dynamic_dependencies(${test_name})
    add_test(NAME ${test_name} COMMAND ${test_name}
        --gtest_color=yes
        --gtest_output=xml:${test_name}.xml
    )
endif()
