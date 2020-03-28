include_guard(DIRECTORY)


function(enable_diagnostics_color)
    get_property(languages GLOBAL PROPERTY ENABLED_LANGUAGES)
    foreach(language IN LISTS languages)
        if(CMAKE_${language}_COMPILER_ID STREQUAL "GNU")
            if(CMAKE_GENERATOR STREQUAL "Ninja")
                add_compile_options($<$<COMPILE_LANGUAGE:${language}>:-fdiagnostics-color>)
            else()
                add_compile_options($<$<COMPILE_LANGUAGE:${language}>:-fdiagnostics-color=auto>)
            endif()
        elseif(CMAKE_${language}_COMPILER_ID MATCHES "Clang")
            if(CMAKE_GENERATOR STREQUAL "Ninja")
                add_compile_options($<$<COMPILE_LANGUAGE:${language}>:-fcolor-diagnostics>)
            endif()
        endif()
    endforeach()
endfunction()


enable_diagnostics_color()
