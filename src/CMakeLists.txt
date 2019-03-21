add_subdirectory(clegacy)
add_subdirectory(example)

add_executable(${PROJECT_NAME})
target_sources(${PROJECT_NAME}
  PRIVATE
    main.cpp
)
target_link_libraries(${PROJECT_NAME}
  PRIVATE
    clegacy
    example
    Threads::Threads
    Boost::system
    Boost::diagnostic_definitions
    Boost::disable_autolinking
    Boost::dynamic_linking
)
debug_dynamic_dependencies(${PROJECT_NAME})
install(TARGETS ${PROJECT_NAME}
    EXPORT ${PROJECT_NAME}
    DESTINATION "${CMAKE_INSTALL_BINDIR}")
