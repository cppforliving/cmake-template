get_filename_component(lib_name "${CMAKE_CURRENT_SOURCE_DIR}" NAME)

include(CheckIncludeFileCXX)
check_include_file_cxx(memory_resource HAVE_MEMORY_RESOURCE)
check_include_file_cxx(experimental/memory_resource HAVE_EXPERIMENTAL_MEMORY_RESOURCE)

if(HAVE_LIBCPP)
  find_library(LIBCPPEXPERIMENTAL c++experimental)
endif()

if(BUILD_TESTING)
    projname_add_test(${lib_name}_test
      SOURCES
        memory_resource_test.cpp
      DEPENDS
        gtest_main
        ${LIBCPPEXPERIMENTAL}
      EXTRA_ARGS
        --gtest_color=yes
    )
    if(HAVE_MEMORY_RESOURCE)
        target_compile_definitions(${lib_name}_test PUBLIC HAVE_MEMORY_RESOURCE)
    endif()
    if(HAVE_EXPERIMENTAL_MEMORY_RESOURCE)
        target_compile_definitions(${lib_name}_test PUBLIC HAVE_EXPERIMENTAL_MEMORY_RESOURCE)
    endif()
endif()
