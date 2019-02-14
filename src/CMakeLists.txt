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
if(APPLE)
    add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
        COMMAND otool -l ${PROJECT_NAME} | grep PATH -A2
        COMMAND otool -L ${PROJECT_NAME})
elseif(NOT MSVC)
    add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
        COMMAND objdump -x ${PROJECT_NAME} | grep PATH
        COMMAND ldd ${PROJECT_NAME})
endif()
install(TARGETS ${PROJECT_NAME}
    DESTINATION "${CMAKE_INSTALL_BINDIR}")
