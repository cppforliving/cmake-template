file(GLOB SOURCE_FILES *.cpp)
add_executable(${PROJECT_NAME}-test ${SOURCE_FILES})
target_link_libraries(${PROJECT_NAME}-test gmock_main)
add_test(NAME ${PROJECT_NAME}-test COMMAND ${PROJECT_NAME}-test)
