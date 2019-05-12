get_filename_component(lib_name "${CMAKE_CURRENT_SOURCE_DIR}" NAME)

add_custom_library(${lib_name}
  SOURCES
    derived.cpp
    derived.hpp
    example.cpp
    example.hpp
    lockable.hpp
)

if(BUILD_TESTING)
    add_custom_test(${lib_name}_test
      SOURCES
        derived_test.cpp
        example_test.cpp
        lockable_test.cpp
      DEPENDS
        ${lib_name}
        gtest_main
      TESTARGS
        --gtest_color=yes
    )
endif()
