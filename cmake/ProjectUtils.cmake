include_guard(DIRECTORY)

include(GNUInstallDirs)
include(CMakePrintHelpers)


macro(eval)
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


macro(projname_parse_arguments prefix options one_value_keywords multi_value_keywords)
    cmake_parse_arguments("${prefix}" "${options}" "${one_value_keywords}" "${multi_value_keywords}" ${ARGN})

    if(${prefix}_UNPARSED_ARGUMENTS)
        message(FATAL_ERROR "Found unparsed arguments: ${${prefix}_UNPARSED_ARGUMENTS}")
    endif()
    if(${prefix}_KEYWORDS_MISSING_VALUES)
        message(FATAL_ERROR "Found keywords missing values: ${${prefix}_KEYWORDS_MISSING_VALUES}")
    endif()
endmacro()


function(projname_install_target tgt_name)
    projname_parse_arguments(arg "" "" "HEADERS" ${ARGN})

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


function(projname_print_target_properties)
    set(props
        TYPE
        IMPORTED
        INTERFACE_INCLUDE_DIRECTORIES
        INTERFACE_LINK_LIBRARIES
        INTERFACE_LINK_OPTIONS
        INTERFACE_COMPILE_DEFINITIONS
        INTERFACE_COMPILE_OPTIONS
        INTERFACE_POSITION_INDEPENDENT_CODE
        INTERFACE_SOURCES
    )
    set(extra_props
        LOCATION
        IMPORTED_LOCATION
    )
    message(STATUS)
    foreach(tgt_name IN LISTS ARGN)
        foreach(prop IN LISTS props)
            get_target_property(prop_value ${tgt_name} ${prop})
            if(prop_value)
                message(STATUS "  ${tgt_name}.${prop} = ${prop_value}")
            endif()
        endforeach()
        get_target_property(tgt_type ${tgt_name} TYPE)
        if(NOT tgt_type STREQUAL "INTERFACE_LIBRARY")
            foreach(prop IN LISTS extra_props)
                get_target_property(prop_value ${tgt_name} ${prop})
                if(prop_value)
                    message(STATUS "  ${tgt_name}.${prop} = ${prop_value}")
                endif()
            endforeach()
        endif()
        message(STATUS)
    endforeach()
endfunction()


function(projname_debug_dynamic_deps tgt_name)
    projname_parse_arguments(arg "" "" "" ${ARGN})

    if(debug_dynamic_deps)
        get_target_property(tgt_type ${tgt_name} TYPE)
        if(NOT tgt_type STREQUAL "INTERFACE_LIBRARY")
            set(tgt_file $<TARGET_FILE:${tgt_name}>)
            if(APPLE)
                add_custom_command(TARGET ${tgt_name} POST_BUILD
                    COMMAND otool -l ${tgt_file} | grep PATH -A2 || :
                    COMMAND otool -D ${tgt_file} || :
                    COMMAND otool -L ${tgt_file} || :)
            elseif(UNIX)
                add_custom_command(TARGET ${tgt_name} POST_BUILD
                    COMMAND objdump -p ${tgt_file} | grep NEEDED || :
                    COMMAND objdump -p ${tgt_file} | grep SONAME || :
                    COMMAND objdump -p ${tgt_file} | grep PATH || :
                    COMMAND ldd -r ${tgt_file} || :)
            elseif(WIN32)
                add_custom_command(TARGET ${tgt_name} POST_BUILD
                    COMMAND dumpbin -DEPENDENTS ${tgt_file})
            endif()
        endif()
    endif()
endfunction()


function(projname_add_test_labels test_name)
    projname_parse_arguments(arg "EXECUTABLE;PYTEST;PYLINT" "" "" ${ARGN})

    if(test_name MATCHES "^tests/")
        set(test_level integration)
    else()
        set(test_level unit)
    endif()

    if(arg_EXECUTABLE)
        if(test_name MATCHES "_test$")
            set_property(TEST ${test_name} APPEND PROPERTY LABELS "${test_level}")
        elseif(test_name MATCHES "_benchmark$")
            set_property(TEST ${test_name} APPEND PROPERTY LABELS benchmark)
        else()
            message(FATAL_ERROR "${test_name} name has to end with '_(test|benchmark)'")
        endif()
    elseif(arg_PYTEST AND test_name MATCHES "/test_[a-z0-9_]*\\.py$")
        set_property(TEST ${test_name} APPEND PROPERTY LABELS "${test_level}")
    elseif(arg_PYLINT AND test_name MATCHES "/test_[a-z0-9_]*\\.py$")
        set_property(TEST ${test_name} APPEND PROPERTY LABELS pylint)
    else()
        message(FATAL_ERROR "${test_name} name has to be 'test_*.py'")
    endif()
endfunction()


function(projname_add_test_environent test_name)
    projname_parse_arguments(arg "SANITIZER_NO_DETECT_LEAKS;SANITIZER_PRELOAD_RUNTIME" "" "" ${ARGN})

    if(${PROJECT_NAME}_sanitizer)
        if(${PROJECT_NAME}_sanitizer STREQUAL "address")
            set(sanitizer_name asan)
            if(arg_SANITIZER_NO_DETECT_LEAKS)
                set_property(TEST ${test_name}
                    APPEND PROPERTY ENVIRONMENT "ASAN_OPTIONS=detect_leaks=0:$ENV{ASAN_OPTIONS}")
            endif()
        elseif(${PROJECT_NAME}_sanitizer STREQUAL "leak")
            set(sanitizer_name lsan)
            if(arg_SANITIZER_NO_DETECT_LEAKS)
                set_property(TEST ${test_name}
                    APPEND PROPERTY ENVIRONMENT "LSAN_OPTIONS=detect_leaks=0:$ENV{LSAN_OPTIONS}")
            endif()
        elseif(${PROJECT_NAME}_sanitizer STREQUAL "thread")
            set(sanitizer_name tsan)
        elseif(${PROJECT_NAME}_sanitizer STREQUAL "memory")
            set(sanitizer_name msan)
        elseif(${PROJECT_NAME}_sanitizer STREQUAL "undefined")
            set(sanitizer_name ubsan)
            if(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
                string(APPEND sanitizer_name _standalone)
            endif()
            set_property(TEST ${test_name}
                APPEND PROPERTY ENVIRONMENT "UBSAN_OPTIONS=halt_on_error=1:suppressions=${PROJECT_SOURCE_DIR}/external/tbb/ubsan.supp:$ENV{UBSAN_OPTIONS}")
        endif()

        if(arg_SANITIZER_PRELOAD_RUNTIME)
            if(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
                set(sanitizer_runtime libclang_rt.${sanitizer_name}-x86_64.so)
            elseif(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
                set(sanitizer_runtime lib${sanitizer_name}.so)
            endif()

            if("$CACHE{projname_sanitizer_runtime}" STREQUAL "")
                eval_out(projname_sanitizer_runtime
                    ${CMAKE_CXX_COMPILER} -print-file-name=${sanitizer_runtime})
                set(projname_sanitizer_runtime "${projname_sanitizer_runtime}" CACHE FILEPATH
                    "Path of the clang asan shared runtime." FORCE)
                mark_as_advanced(projname_sanitizer_runtime)
            endif()

            if(projname_sanitizer_runtime MATCHES "/")
                set_property(TEST ${test_name}
                    APPEND PROPERTY ENVIRONMENT "LD_PRELOAD=${projname_sanitizer_runtime} $ENV{LD_PRELOAD}")
            endif()
        endif()
    endif()
endfunction()
