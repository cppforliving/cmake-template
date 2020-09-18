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
        /wd4275  # fmt exceptions export
        /wd4455  # false positive bug
    )
    add_compile_definitions(
        _HAS_EXCEPTIONS=1
        _SILENCE_CXX17_ALLOCATOR_VOID_DEPRECATION_WARNING
    )
else()
    add_compile_options(
        -fno-strict-aliasing
        $<$<CONFIG:Debug>:-fno-omit-frame-pointer>
        -pedantic
        -Wall
        -Wcast-align
        -Wcast-qual
        -Wconversion
        -Werror
        -Wextra
        -Wsign-conversion
        -Wswitch-enum
        -Wwrite-strings
        $<$<COMPILE_LANGUAGE:CXX>:-Wc++17-compat>
        $<$<COMPILE_LANGUAGE:CXX>:-Wctor-dtor-privacy>
        $<$<COMPILE_LANGUAGE:CXX>:-Wnon-virtual-dtor>
        $<$<COMPILE_LANGUAGE:CXX>:-Wold-style-cast>
        $<$<COMPILE_LANGUAGE:CXX>:-Woverloaded-virtual>
        $<$<COMPILE_LANGUAGE:CXX>:-Wzero-as-null-pointer-constant>
    )
    if(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
        add_compile_options(
            -Weverything
            -Wno-c++98-compat
            -Wno-c++98-compat-pedantic
            -Wno-shadow-uncaptured-local
        )
    elseif(CMAKE_CXX_COMPILER_ID STREQUAL "GNU" AND CMAKE_CXX_COMPILER_VERSION VERSION_LESS "8")
        add_compile_options(-Wno-error=literal-suffix)  # false positive bug
    endif()
    if(HAVE_GLIBCXX)
        add_compile_definitions(
            $<$<COMPILE_LANGUAGE:CXX>:_GLIBCXX_ASSERTIONS>
        )
    endif()
    if(NOT ${PROJECT_NAME}_sanitizer)
        if(APPLE)
            add_link_options($<$<NOT:$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>>:LINKER:-undefined,error>)
        else()
            add_link_options($<$<NOT:$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>>:LINKER:-z,defs>)
        endif()
    endif()
endif()
