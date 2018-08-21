add_executable(${PROJECT_NAME}-test example-test.cpp)
target_link_libraries(${PROJECT_NAME}-test gmock_main)
add_test(NAME ${PROJECT_NAME}-test COMMAND ${PROJECT_NAME}-test)
