add_subdirectory(clegacy)
add_subdirectory(example)

add_executable(${PROJECT_NAME} main.cpp)
target_link_libraries(${PROJECT_NAME}
    clegacy
    example
    Threads::Threads
    Boost::system
    Boost::diagnostic_definitions
    Boost::disable_autolinking
    Boost::dynamic_linking
)
debug_dynamic_depencencies(${PROJECT_NAME})
install(TARGETS ${PROJECT_NAME}
    DESTINATION "${CMAKE_INSTALL_BINDIR}")
