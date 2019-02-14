if(MSVC)
    add_compile_options(
        -EHsc
        -W4
        -WX
        -Zc:__cplusplus
        -nologo
        -permissive-
    )
    add_definitions(
        -D_HAS_EXCEPTIONS=1
    )
else()
    add_compile_options(
        -fno-strict-aliasing
        -pedantic
        -Wall
        -Wcast-align
        -Wconversion
        -Werror
        -Wextra
        -Wshadow
        -Wsign-conversion
        $<$<COMPILE_LANGUAGE:CXX>:-Wctor-dtor-privacy>
        $<$<COMPILE_LANGUAGE:CXX>:-Wnon-virtual-dtor>
        $<$<COMPILE_LANGUAGE:CXX>:-Wold-style-cast>
        $<$<COMPILE_LANGUAGE:CXX>:-Woverloaded-virtual>
        $<$<CXX_COMPILER_ID:GNU>:-Wl,--function-sections>
        $<$<CXX_COMPILER_ID:GNU>:-Wl,--data-sections>
        $<$<CXX_COMPILER_ID:GNU>:-Wl,--gc-sections>
    )
endif()