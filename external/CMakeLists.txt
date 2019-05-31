add_subdirectory(threads)
add_subdirectory(boost)
#add_subdirectory(gsl)

if(BUILD_TESTING)
    add_subdirectory(catch2)
    add_subdirectory(gtest)
endif()
