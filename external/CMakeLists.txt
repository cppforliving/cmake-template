add_subdirectory(threads)
add_subdirectory(boost)
add_subdirectory(gsl)

if(BUILD_TESTING)
    add_subdirectory(catch)
    add_subdirectory(gtest)
endif()
