option(build_thread_safety "Build for thread safety analysis." OFF)

if(build_thread_safety)
    if(${CMAKE_CXX_COMPILER_ID} MATCHES Clang)
        add_compile_options(-Wthread-safety)
    else()
        message(FATAL_ERROR "build_thread_safety not supported yet for ${CMAKE_CXX_COMPILER_ID}")
    endif()
endif()
