add_subdirectory(clegacy)
add_subdirectory(example)

add_executable(${PROJECT_NAME} main.cpp)
target_link_libraries(${PROJECT_NAME}
    clegacy
    example
    Threads::Threads
    Boost::system
)
debug_dynamic_dependencies(${PROJECT_NAME})
install(TARGETS ${PROJECT_NAME}
    EXPORT ${PROJECT_NAME}
    DESTINATION "${CMAKE_INSTALL_BINDIR}")
