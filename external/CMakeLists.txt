add_subdirectory(threads)

add_subdirectory(asio)
add_subdirectory(span-lite)
add_subdirectory(spdlog)
add_subdirectory(tbb)
add_subdirectory(tl)

if(BUILD_TESTING)
    add_subdirectory(catch2)
    add_subdirectory(doctest)
    add_subdirectory(gtest)
    add_subdirectory(benchmark)
endif()
