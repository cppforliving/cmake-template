set(build_coverage "" CACHE STRING "Build for coverage analysis. Coverage report types: html, xml.")

if(build_coverage)
    if(MSVC)
        message(FATAL_ERROR "build_coverage not supported yet for MSVC")
    else()
        add_compile_options(--coverage)
    endif()
endif()
