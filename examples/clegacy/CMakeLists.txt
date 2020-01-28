get_filename_component(lib_name "${CMAKE_CURRENT_SOURCE_DIR}" NAME)

projname_add_library(${lib_name}
  SOURCES
    clegacy.cpp
    clegacy.h
)

if(BUILD_TESTING)
    projname_add_test(${lib_name}_test
      SOURCES
        clegacy_test.cpp
      DEPENDS
        ${lib_name}
        gtest_main
      EXTRA_ARGS
        --gtest_color=yes
    )
endif()
