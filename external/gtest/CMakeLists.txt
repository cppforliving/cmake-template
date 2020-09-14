include(FetchContent)

FetchContent_Declare(googletest
    GIT_REPOSITORY https://github.com/google/googletest.git
    GIT_TAG release-1.10.0
)

if(NOT MSVC)
    #add_compile_options(-Wno-error)
    add_compile_options(
        -Wno-ctor-dtor-privacy
        -Wno-sign-conversion
        -Wno-switch-enum
        -Wno-zero-as-null-pointer-constant
    )
    if(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
        add_compile_options(
            -Wno-comma
            -Wno-covered-switch-default
            -Wno-disabled-macro-expansion
            -Wno-exit-time-destructors
            -Wno-extra-semi-stmt
            -Wno-format-nonliteral
            -Wno-global-constructors
            -Wno-missing-noreturn
            -Wno-missing-prototypes
            -Wno-padded
            -Wno-shift-sign-overflow
            -Wno-undef
            -Wno-unused-member-function
            -Wno-used-but-marked-unused
            -Wno-weak-vtables
        )
        if(NOT CMAKE_CXX_COMPILER_ID STREQUAL "AppleClang")
            add_compile_options(
                -Wno-deprecated
                -Wno-deprecated-copy-dtor
            )
        endif()
    endif()
endif()

set(CMAKE_CXX_VISIBILITY_PRESET default)
set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)

FetchContent_MakeAvailable(googletest)

projname_print_target_properties(gtest_main)
projname_print_target_properties(gtest)
projname_print_target_properties(gmock_main)
projname_print_target_properties(gmock)
target_link_libraries(gtest_main
  INTERFACE
    gtest
    gmock
)
if(BUILD_SHARED_LIBS)
    target_compile_definitions(gtest_main
    INTERFACE
        GTEST_LINKED_AS_SHARED_LIBRARY=1
        #GTEST_REMOVE_LEGACY_TEST_CASEAPI_
    )
endif()
if(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    target_compile_options(gtest_main
      INTERFACE
        -Wno-global-constructors
        -Wno-gnu-zero-variadic-macro-arguments
    )
endif()
