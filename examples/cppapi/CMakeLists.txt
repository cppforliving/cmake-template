get_filename_component(lib_name "${CMAKE_CURRENT_SOURCE_DIR}" NAME)

add_custom_library(${lib_name}
  SOURCES
    cppapi.cpp
    cppapi.hpp
)

if(BUILD_TESTING)
    add_custom_test(${lib_name}_test
      SOURCES
        cppapi_test.cpp
      DEPENDS
        ${lib_name}
        gtest_main
      EXTRA_ARGS
        --gtest_color=yes
    )
endif()
