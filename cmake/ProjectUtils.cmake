include_guard(DIRECTORY)

include(GNUInstallDirs)
include(CMakePrintHelpers)


macro(eval)
    string(REPLACE ";" " " argn "${ARGN}")
    execute_process(COMMAND ${ARGN} RESULT_VARIABLE ret)
    if(ret)
        string(REPLACE ";" " " msg "'${ARGN}' failed with error code ${ret}")
        message(FATAL_ERROR "${msg}")
    endif()
endmacro()


macro(eval_out output)
    eval(${ARGN} OUTPUT_STRIP_TRAILING_WHITESPACE OUTPUT_VARIABLE ${output})
    cmake_print_variables(${output})
endmacro()


function(validate_arguments prefix)
    if(${prefix}_UNPARSED_ARGUMENTS)
        message(FATAL_ERROR "Found unparsed arguments: ${${prefix}_UNPARSED_ARGUMENTS}")
    endif()
    if(${prefix}_KEYWORDS_MISSING_VALUES)
        message(FATAL_ERROR "Found keywords missing values: ${${prefix}_KEYWORDS_MISSING_VALUES}")
    endif()
endfunction()


function(projname_install_target tgt_name)
    set(options)
    set(one_value_args)
    set(multi_value_args HEADERS)
    cmake_parse_arguments(arg "${options}"
        "${one_value_args}" "${multi_value_args}" ${ARGN})
    validate_arguments(arg)

    get_filename_component(parent_source_dir "${CMAKE_CURRENT_SOURCE_DIR}" DIRECTORY)
    get_filename_component(parent_source_dir_name "${parent_source_dir}" NAME)
    if("${parent_source_dir_name}" STREQUAL "examples")
        set(install_prefix "${CMAKE_INSTALL_DATAROOTDIR}/${PROJECT_NAME}/examples/")
    endif()
    if(arg_HEADERS)
        target_include_directories(${tgt_name} SYSTEM
          INTERFACE
            $<INSTALL_INTERFACE:${install_prefix}${CMAKE_INSTALL_INCLUDEDIR}>
        )
        install(FILES ${arg_HEADERS}
            DESTINATION "${install_prefix}${CMAKE_INSTALL_INCLUDEDIR}/${tgt_name}")
    endif()
    # install(DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/"
    #     DESTINATION "${install_prefix}${CMAKE_INSTALL_INCLUDEDIR}/${tgt_name}"
    #     FILES_MATCHING REGEX ${header_regex})
    install(TARGETS ${tgt_name}
        EXPORT ${PROJECT_NAME}-targets
        RUNTIME DESTINATION "${install_prefix}${CMAKE_INSTALL_BINDIR}"
                COMPONENT ${PROJECT_NAME}_Runtime
        LIBRARY DESTINATION "${install_prefix}${CMAKE_INSTALL_LIBDIR}"
                COMPONENT ${PROJECT_NAME}_Runtime
                NAMELINK_COMPONENT ${PROJECT_NAME}_Development
        ARCHIVE DESTINATION "${install_prefix}${CMAKE_INSTALL_LIBDIR}"
                COMPONENT ${PROJECT_NAME}_Development)
endfunction()


function(debug_dynamic_dependencies tgt_name)
    if(NOT debug_dynamic_deps)
        return()
    endif()

    set(tgt_file $<TARGET_FILE:${tgt_name}>)
    if(APPLE)
        add_custom_command(TARGET ${tgt_name} POST_BUILD
            COMMAND otool -l ${tgt_file} | grep PATH -A2 || :
            COMMAND otool -L ${tgt_file} || :)
    elseif(UNIX)
        add_custom_command(TARGET ${tgt_name} POST_BUILD
            COMMAND readelf -d ${tgt_file} | grep NEEDED || :
            COMMAND readelf -d ${tgt_file} | grep PATH || :
            COMMAND ldd -r ${tgt_file} || :)
    elseif(WIN32)
        add_custom_command(TARGET ${tgt_name} POST_BUILD
            COMMAND dumpbin -DEPENDENTS ${tgt_file})
    endif()
endfunction()
