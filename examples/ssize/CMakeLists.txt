get_filename_component(lib_name "${CMAKE_CURRENT_SOURCE_DIR}" NAME)

projname_add_library(${lib_name} INTERFACE
  SOURCES
    ssize.hpp
)

if(BUILD_TESTING)
    projname_add_test(${lib_name}_test
      SOURCES
        ssize_test.cpp
      DEPENDS
        ${lib_name}
        gtest_main
      EXTRA_ARGS
        --gtest_color=yes
    )
endif()
