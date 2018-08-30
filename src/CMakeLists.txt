set(SOURCE_FILES main.cpp)
add_executable(${PROJECT_NAME} ${SOURCE_FILES})
add_subdirectory(example)
target_link_libraries(${PROJECT_NAME} example)
