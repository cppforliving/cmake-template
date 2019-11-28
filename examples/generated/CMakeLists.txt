get_filename_component(lib_name "${CMAKE_CURRENT_SOURCE_DIR}" NAME)

add_custom_command(OUTPUT
    enum.hpp
  COMMAND Python2::Interpreter
    "${CMAKE_CURRENT_SOURCE_DIR}/generator.py"
    "${CMAKE_CURRENT_SOURCE_DIR}/templates"
  DEPENDS
    generator.py
    templates/enum.hpp.jinja2
)

add_custom_library(${lib_name} INTERFACE
  SOURCES
    "${CMAKE_CURRENT_BINARY_DIR}/enum.hpp"
)

if(BUILD_TESTING)
    add_custom_test(${lib_name}_test
      SOURCES
        generated_test.cpp
      DEPENDS
        ${lib_name}
        gtest_main
      EXTRA_ARGS
        --gtest_color=yes
    )
endif()
