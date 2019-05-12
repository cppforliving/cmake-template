get_filename_component(lib_name "${CMAKE_CURRENT_SOURCE_DIR}" NAME)

add_custom_library(${lib_name}
  SOURCES
    clegacy.c
    clegacy.h
)

if(BUILD_TESTING)
    add_custom_test(${lib_name}_test
      SOURCES
        clegacy_test.cpp
      DEPENDS
        ${lib_name}
        gtest_main
      TESTARGS
        --gtest_color=yes
    )
endif()
