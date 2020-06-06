include(CheckIncludeFileCXX)


projname_add_test(memory_resource_test
  SOURCES
    memory_resource_test.cpp
  DEPENDS
    finally
    gtest_main
  EXTRA_ARGS
    --gtest_color=yes
)
check_include_file_cxx(memory_resource HAVE_MEMORY_RESOURCE)
check_include_file_cxx(experimental/memory_resource HAVE_EXPERIMENTAL_MEMORY_RESOURCE)
if(HAVE_LIBCPP AND NOT HAVE_MEMORY_RESOURCE AND HAVE_EXPERIMENTAL_MEMORY_RESOURCE)
    target_link_libraries(memory_resource_test PUBLIC c++experimental)
endif()
if(HAVE_MEMORY_RESOURCE)
    target_compile_definitions(memory_resource_test PUBLIC HAVE_MEMORY_RESOURCE)
endif()
if(HAVE_EXPERIMENTAL_MEMORY_RESOURCE)
    target_compile_definitions(memory_resource_test PUBLIC HAVE_EXPERIMENTAL_MEMORY_RESOURCE)
endif()
