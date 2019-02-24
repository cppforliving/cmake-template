option(${PROJECT_NAME}_profiling "Build for performance analysis." OFF)

if(${PROJECT_NAME}_profiling)
    if(MSVC)
        message(FATAL_ERROR "${PROJECT_NAME}_profiling not supported yet for MSVC")
    else()
        add_compile_options(-pg)
    endif()
endif()
