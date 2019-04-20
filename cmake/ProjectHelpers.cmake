function(debug_dynamic_dependencies target_name)
    if(NOT debug_dynamic_deps)
        return()
    endif()

    set(target_file $<TARGET_FILE:${target_name}>)
    if(APPLE)
        add_custom_command(TARGET ${target_name} POST_BUILD
            COMMAND otool -l ${target_file} | grep PATH -A2 || :
            COMMAND otool -L ${target_file} || :)
    elseif(UNIX)
        add_custom_command(TARGET ${target_name} POST_BUILD
            COMMAND objdump -p ${target_file} | grep PATH || :
            COMMAND ldd ${target_file} || :)
    elseif(WIN32)
        add_custom_command(TARGET ${target_name} POST_BUILD
            COMMAND dumpbin -DEPENDENTS ${target_file})
    endif()
endfunction()

function(add_gtest_test test_name)
    set(options)
    set(one_value_args)
    set(multi_value_args SOURCES DEPENDS)
    cmake_parse_arguments(${test_name} "${options}"
        "${one_value_args}" "${multi_value_args}" ${ARGN})

    add_executable(${test_name})
    target_sources(${test_name}
      PRIVATE
        ${${test_name}_SOURCES}
    )
    target_link_libraries(${test_name}
      PRIVATE
        GTest::Main
        GTest::GTest
        ${${test_name}_DEPENDS}
    )
    target_compile_definitions(${test_name}
      PRIVATE
        GTEST_LINKED_AS_SHARED_LIBRARY=1
    )
    if(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
        target_compile_options(${test_name}
          PRIVATE
            -Wno-global-constructors
            -Wno-gnu-zero-variadic-macro-arguments
            -Wno-zero-as-null-pointer-constant
        )
    endif()
    debug_dynamic_dependencies(${test_name})
    add_test(NAME ${test_name} COMMAND ${test_name}
        --gtest_color=yes
        --gtest_output=xml:${test_name}.xml
    )
endfunction()

function(add_catch_test test_name)
    set(options)
    set(one_value_args)
    set(multi_value_args SOURCES DEPENDS)
    cmake_parse_arguments(${test_name} "${options}"
        "${one_value_args}" "${multi_value_args}" ${ARGN})

    add_executable(${test_name})
    target_sources(${test_name}
      PRIVATE
        ${${test_name}_SOURCES}
    )
    target_link_libraries(${test_name}
      PRIVATE
        catch_main
        Catch2::Catch2
        ${${test_name}_DEPENDS}
    )
    debug_dynamic_dependencies(${test_name})
    add_test(NAME ${test_name} COMMAND ${test_name}
        --use-colour=yes
    )
endfunction()
