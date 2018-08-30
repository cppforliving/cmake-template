set(LIBRARY_NAME example)
set(SOURCE_FILES example.cpp)
add_library(${LIBRARY_NAME} ${SOURCE_FILES})
target_include_directories(${LIBRARY_NAME}
    INTERFACE ${PROJECT_SOURCE_DIR}/src
    PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})
