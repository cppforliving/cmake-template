set(${PROJECT_NAME}_coverage "" CACHE STRING
    "Build for coverage analysis. Coverage report types: html, xml.")

if(${PROJECT_NAME}_coverage)
    if(MSVC)
        message(FATAL_ERROR "${PROJECT_NAME}_coverage not supported yet for MSVC")
    else()
        add_compile_options(--coverage)
    endif()
endif()
