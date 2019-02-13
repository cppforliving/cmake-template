if("${CMAKE_GENERATOR}" STREQUAL Ninja)
    if(${CMAKE_CXX_COMPILER_ID} STREQUAL GNU)
        add_compile_options(-fdiagnostics-color)
    elseif(${CMAKE_CXX_COMPILER_ID} MATCHES Clang)
        add_compile_options(-fcolor-diagnostics)
    endif()
endif()
