include(CheckCXXSymbolExists)

if(NOT HAVE_CPPLIB AND NOT HAVE_LIBCPP AND NOT HAVE_GLIBCXX)
    check_cxx_symbol_exists(_CPPLIB_VER "ciso646" HAVE_CPPLIB)
    check_cxx_symbol_exists(_LIBCPP_VERSION "ciso646" HAVE_LIBCPP)
    check_cxx_symbol_exists(__GLIBCXX__ "ciso646" HAVE_GLIBCXX)
endif()

if(MSVC)
    add_compile_options(
        /EHsc
        /W4
        /WX
        /Zc:__cplusplus
        /nologo
        /permissive-
    )
    add_compile_definitions(
        _HAS_EXCEPTIONS=1
        _SILENCE_CXX17_ALLOCATOR_VOID_DEPRECATION_WARNING
    )
else()
    add_compile_options(
        -fno-strict-aliasing
        $<$<CONFIG:Debug>:-fno-omit-frame-pointer>
        -Wall
        -Wcast-align
        -Wcast-qual
        -Wconversion
        -Werror
        -Wextra
        -Wpedantic
        -Wshadow -Wno-error=shadow
        -Wsign-conversion
        -Wswitch-enum -Wno-error=switch-enum
        -Wwrite-strings
        $<$<COMPILE_LANGUAGE:C>:-Wbad-function-cast>
        $<$<COMPILE_LANGUAGE:C>:-Wc++-compat>
        $<$<COMPILE_LANGUAGE:CXX>:-Wc++17-compat>
        $<$<COMPILE_LANGUAGE:CXX>:-Wctor-dtor-privacy>
        $<$<COMPILE_LANGUAGE:CXX>:-Wnon-virtual-dtor>
        $<$<COMPILE_LANGUAGE:CXX>:-Wold-style-cast>
        $<$<COMPILE_LANGUAGE:CXX>:-Woverloaded-virtual>
        $<$<COMPILE_LANGUAGE:CXX>:-Wzero-as-null-pointer-constant>
        $<$<COMPILE_LANGUAGE:CXX>:-Wno-error=zero-as-null-pointer-constant>
    )
    if(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
        add_compile_options(
            -fcomment-block-commands=startuml,enduml
            -Weverything
            -Wno-c++98-compat
            -Wno-error=documentation
        )
    endif()
    if(HAVE_GLIBCXX)
        add_compile_definitions(
            $<$<COMPILE_LANGUAGE:CXX>:_GLIBCXX_ASSERTIONS>
            $<$<AND:$<COMPILE_LANGUAGE:CXX>,$<CONFIG:Debug>>:_GLIBCXX_DEBUG>
            $<$<AND:$<COMPILE_LANGUAGE:CXX>,$<CONFIG:Debug>>:_GLIBCXX_DEBUG_PEDANTIC>
        )
    endif()
endif()
