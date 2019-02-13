option(build_profiling "Build for performance analysis." OFF)

if(build_profiling)
    if(MSVC)
        message(FATAL_ERROR "build_profiling not supported yet for MSVC")
    else()
        add_compile_options(-pg)
    endif()
endif()
