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
