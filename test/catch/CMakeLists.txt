add_library(catch_main catch_main.cpp)
set_property(TARGET catch_main
    PROPERTY CXX_VISIBILITY_PRESET default)
target_link_libraries(catch_main Catch2::Catch2)
