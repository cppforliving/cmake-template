add_subdirectory(threads)
add_subdirectory(boost)
add_subdirectory(sqlite3)

if(BUILD_TESTING)
    add_subdirectory(catch2)
    add_subdirectory(gtest)
endif()
