include(CheckIncludeFileCXX)


projname_add_test(memory_resource_test
  SOURCES
    memory_resource_test.cpp
  DEPENDS
    finally
    fmt::fmt
    gtest_main
  EXTRA_ARGS
    --gtest_color=yes
)
if(TARGET memory_resource_test)
    check_include_file_cxx(memory_resource HAVE_MEMORY_RESOURCE)
    if(HAVE_MEMORY_RESOURCE)
        target_compile_definitions(memory_resource_test PUBLIC HAVE_MEMORY_RESOURCE)
    else()
        check_include_file_cxx(experimental/memory_resource HAVE_EXPERIMENTAL_MEMORY_RESOURCE)
        if(HAVE_EXPERIMENTAL_MEMORY_RESOURCE)
            target_compile_definitions(memory_resource_test PUBLIC HAVE_EXPERIMENTAL_MEMORY_RESOURCE)
            if(HAVE_LIBCPP)
                target_link_libraries(memory_resource_test PUBLIC c++experimental)
            endif()
        endif()
    endif()
endif()
