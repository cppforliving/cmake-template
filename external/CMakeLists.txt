add_subdirectory(threads)

add_subdirectory(asio)
add_subdirectory(spdlog)
add_subdirectory(tbb)

if(BUILD_TESTING)
    add_subdirectory(benchmark)
    add_subdirectory(catch2)
    add_subdirectory(doctest)
    add_subdirectory(gtest)
endif()
