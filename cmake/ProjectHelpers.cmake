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
    set(multi_value_args SOURCES DEPENDS)
    cmake_parse_arguments(${lib_name} "${options}"
        "${one_value_args}" "${multi_value_args}" ${ARGN})

    add_library(${lib_name})
    add_library(${PROJECT_NAME}::${lib_name} ALIAS ${lib_name})
    target_sources(${lib_name}
      PRIVATE
        ${${lib_name}_SOURCES}
        "${CMAKE_CURRENT_BINARY_DIR}/config.h"
    )
    get_filename_component(parent_source_dir "${CMAKE_CURRENT_SOURCE_DIR}" DIRECTORY)
    get_filename_component(parent_binary_dir "${CMAKE_CURRENT_BINARY_DIR}" DIRECTORY)
    target_include_directories(${lib_name}
      PUBLIC
        $<BUILD_INTERFACE:${parent_source_dir}>
        $<BUILD_INTERFACE:${parent_binary_dir}>
        $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
    )
    target_link_libraries(${lib_name}
      PUBLIC
        ${${lib_name}_DEPENDS}
    )
    debug_dynamic_dependencies(${lib_name})
    include(GenerateExportHeader)
    generate_export_header(${lib_name}
        EXPORT_FILE_NAME config.h
        DEFINE_NO_DEPRECATED
    )

    get_filename_component(parent_source_dir_name "${parent_source_dir}" NAME)
    if(NOT "${parent_source_dir_name}" STREQUAL "examples")
        install(TARGETS ${lib_name}
            EXPORT ${PROJECT_NAME}Targets
            DESTINATION "${CMAKE_INSTALL_LIBDIR}")
        install(DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/"
            DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}/${lib_name}"
            FILES_MATCHING REGEX "/.*\\.h(h|pp|xx)?$")
        install(FILES "${CMAKE_CURRENT_BINARY_DIR}/config.h"
            DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}/${lib_name}")
    endif()
endfunction()

function(add_custom_executable exe_name)
    set(options)
    set(one_value_args)
    set(multi_value_args SOURCES DEPENDS)
    cmake_parse_arguments(${exe_name} "${options}"
        "${one_value_args}" "${multi_value_args}" ${ARGN})

    add_executable(${exe_name}_app)
    set_target_properties(${exe_name}_app
      PROPERTIES
        OUTPUT_NAME ${exe_name}
    )
    target_sources(${exe_name}_app
      PRIVATE
        ${${exe_name}_SOURCES}
    )
    get_filename_component(parent_source_dir "${CMAKE_CURRENT_SOURCE_DIR}" DIRECTORY)
    get_filename_component(parent_binary_dir "${CMAKE_CURRENT_BINARY_DIR}" DIRECTORY)
    target_include_directories(${exe_name}_app
      PUBLIC
        $<BUILD_INTERFACE:${parent_source_dir}>
        $<BUILD_INTERFACE:${parent_binary_dir}>
        $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
    )
    target_link_libraries(${exe_name}_app
      PUBLIC
        ${${exe_name}_DEPENDS}
    )
    debug_dynamic_dependencies(${exe_name}_app)

    get_filename_component(parent_source_dir_name "${parent_source_dir}" NAME)
    if(NOT "${parent_source_dir_name}" STREQUAL "examples")
        install(TARGETS ${exe_name}_app
            EXPORT ${PROJECT_NAME}Targets
            DESTINATION "${CMAKE_INSTALL_BINDIR}")
    endif()
endfunction()

function(add_custom_test test_name)
    set(options)
    set(one_value_args)
    set(multi_value_args SOURCES DEPENDS EXTRA_ARGS)
    cmake_parse_arguments(${test_name} "${options}"
        "${one_value_args}" "${multi_value_args}" ${ARGN})

    add_executable(${test_name})
    target_sources(${test_name}
      PRIVATE
        ${${test_name}_SOURCES}
    )
    target_link_libraries(${test_name}
      PUBLIC
        ${${test_name}_DEPENDS}
    )
    debug_dynamic_dependencies(${test_name})
    add_test(NAME ${test_name} COMMAND ${test_name}
        ${${test_name}_EXTRA_ARGS}
    )
endfunction()
