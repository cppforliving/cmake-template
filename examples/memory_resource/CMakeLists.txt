get_filename_component(lib_name "${CMAKE_CURRENT_SOURCE_DIR}" NAME)

if(BUILD_TESTING)
    projname_add_test(${lib_name}_test
      SOURCES
        memory_resource_test.cpp
      DEPENDS
        gtest_main
      EXTRA_ARGS
        --gtest_color=yes
    )
endif()
