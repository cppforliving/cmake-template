if(MSVC)
    add_compile_options(
        /EHsc
        /W4
        /WX
        /Zc:__cplusplus
        /nologo
        /permissive-
    )
    add_definitions(
        /D_HAS_EXCEPTIONS=1
    )
else()
    add_compile_options(
        -fno-strict-aliasing
        -Wall
        -Wcast-align
        -Wconversion
        -Werror
        -Wextra
        -Wpedantic
        -Wshadow
        -Wsign-conversion
        $<$<COMPILE_LANGUAGE:C>:-Wc++-compat>
        $<$<COMPILE_LANGUAGE:CXX>:-Wc++17-compat>
        $<$<COMPILE_LANGUAGE:CXX>:-Wctor-dtor-privacy>
        $<$<COMPILE_LANGUAGE:CXX>:-Wnon-virtual-dtor>
        $<$<COMPILE_LANGUAGE:CXX>:-Wold-style-cast>
        $<$<COMPILE_LANGUAGE:CXX>:-Woverloaded-virtual>
    )
    if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
        add_compile_options(
            $<$<COMPILE_LANGUAGE:CXX>:-Wsuggest-override>
        )
    elseif(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
        add_compile_options(
            -Wno-error=gnu-zero-variadic-macro-arguments
        )
    endif()
    set(linker_flags
        #-Wl,--function-sections
        #-Wl,--data-sections
        #-Wl,--gc-sections
    )
    string(REPLACE ";" " " linker_flags "${linker_flags}")
    string(APPEND CMAKE_SHARED_LINKER_FLAGS " ${linker_flags}")
    unset(linker_flags)
endif()