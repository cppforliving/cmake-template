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

function(add_custom_library lib_name)
    set(options)
    set(one_value_args)
    set(multi_value_args SOURCES)
    cmake_parse_arguments(${lib_name} "${options}"
        "${one_value_args}" "${multi_value_args}" ${ARGN})

    add_library(${lib_name})
    target_sources(${lib_name}
      PRIVATE
        ${${lib_name}_SOURCES}
        "${CMAKE_CURRENT_BINARY_DIR}/export.h"
    )
    target_include_directories(${lib_name}
      PUBLIC
        $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/src>
        $<BUILD_INTERFACE:${PROJECT_BINARY_DIR}/src>
        $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
    )
    include(GenerateExportHeader)
    generate_export_header(${lib_name}
        EXPORT_FILE_NAME export.h
    )

    install(TARGETS ${lib_name}
        EXPORT ${PROJECT_NAME}Targets
        DESTINATION "${CMAKE_INSTALL_LIBDIR}")
    install(DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/"
        DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}/${lib_name}"
        FILES_MATCHING REGEX "/.*\\.h(h|pp|xx)?$")
    install(FILES "${CMAKE_CURRENT_BINARY_DIR}/export.h"
        DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}/${lib_name}")
endfunction()

function(add_custom_test test_name)
    set(options)
    set(one_value_args)
    set(multi_value_args SOURCES DEPENDS TESTARGS)
    cmake_parse_arguments(${test_name} "${options}"
        "${one_value_args}" "${multi_value_args}" ${ARGN})

    add_executable(${test_name})
    target_sources(${test_name}
      PRIVATE
        ${${test_name}_SOURCES}
    )
    target_link_libraries(${test_name}
      PRIVATE
        ${${test_name}_DEPENDS}
    )
    debug_dynamic_dependencies(${test_name})
    add_test(NAME ${test_name} COMMAND ${test_name}
        ${${test_name}_TESTARGS}
    )
endfunction()
