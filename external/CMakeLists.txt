add_subdirectory(threads)
add_subdirectory(boost)

if(BUILD_TESTING)
    add_subdirectory(catch2)
    add_subdirectory(gtest)
    add_subdirectory(benchmark)
endif()
