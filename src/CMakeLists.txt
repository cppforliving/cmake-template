add_subdirectory(clegacy)
add_subdirectory(example)

set(SOURCE_FILES main.cpp)
add_executable(${PROJECT_NAME} ${SOURCE_FILES})
target_link_libraries(${PROJECT_NAME} clegacy example
    Threads::Threads Boost::system
    Boost::diagnostic_definitions
    #Boost::disable_autolinking
    Boost::dynamic_linking
)
install(TARGETS ${PROJECT_NAME}
    DESTINATION "${CMAKE_INSTALL_BINDIR}")
