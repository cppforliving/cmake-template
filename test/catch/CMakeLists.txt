set(CMAKE_CXX_VISIBILITY_PRESET default)
add_library(catch_main catch_main.cpp)
target_link_libraries(catch_main Catch2::Catch2)
