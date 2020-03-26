include_guard(GLOBAL)

include(GNUInstallDirs)
include(GenerateExportHeader)

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

function(projname_add_library tgt_name)
    set(options INTERFACE)
    set(one_value_args)
    set(multi_value_args SOURCES DEPENDS)
    cmake_parse_arguments(arg "${options}"
        "${one_value_args}" "${multi_value_args}" ${ARGN})

    set(header_regex ".*\\.h(h|pp|xx|\\+\\+)?$")
    list(TRANSFORM arg_SOURCES
        PREPEND "${CMAKE_CURRENT_SOURCE_DIR}/"
        REGEX "^[^\/][^:].*"
    )
    set(arg_HEADERS ${arg_SOURCES})
    list(FILTER arg_SOURCES EXCLUDE REGEX ${header_regex})
    list(FILTER arg_HEADERS INCLUDE REGEX ${header_regex})

    if(arg_INTERFACE)
        set(lib_type INTERFACE)
        set(visibility INTERFACE)
    else()
        set(visibility PUBLIC)
    endif()

    add_library(${tgt_name} ${lib_type})
    add_library(${PROJECT_NAME}::${tgt_name} ALIAS ${tgt_name})
    if(NOT arg_INTERFACE)
        generate_export_header(${tgt_name}
            EXPORT_FILE_NAME export.h
            DEFINE_NO_DEPRECATED
        )
        list(APPEND arg_HEADERS "${CMAKE_CURRENT_BINARY_DIR}/export.h")
        set_target_properties(${tgt_name}
          PROPERTIES
            SOVERSION ${PROJECT_VERSION_MAJOR}
            VERSION ${PROJECT_VERSION}
        )
        if(UNIX AND NOT APPLE)
            set_target_properties(${tgt_name}
              PROPERTIES
                INSTALL_RPATH "$ORIGIN"
            )
        endif()
        target_sources(${tgt_name}
          PRIVATE
            ${arg_SOURCES}
        )
    endif()
    target_sources(${tgt_name}
      ${visibility}
        "$<BUILD_INTERFACE:${arg_HEADERS}>"
    )
    get_filename_component(parent_source_dir "${CMAKE_CURRENT_SOURCE_DIR}" DIRECTORY)
    get_filename_component(parent_binary_dir "${CMAKE_CURRENT_BINARY_DIR}" DIRECTORY)
    target_include_directories(${tgt_name}
      ${visibility}
        $<BUILD_INTERFACE:${parent_source_dir}>
        $<BUILD_INTERFACE:${parent_binary_dir}>
    )
    target_include_directories(${tgt_name} SYSTEM
      INTERFACE
        $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
    )
    target_link_libraries(${tgt_name}
      ${visibility}
        ${arg_DEPENDS}
    )
    if(NOT arg_INTERFACE)
        debug_dynamic_dependencies(${tgt_name})
    endif()

    get_filename_component(parent_source_dir_name "${parent_source_dir}" NAME)
    if("${parent_source_dir_name}" STREQUAL "examples")
        set(install_prefix "${CMAKE_INSTALL_DATAROOTDIR}/${PROJECT_NAME}/examples/")
    endif()
    install(TARGETS ${tgt_name}
        EXPORT ${PROJECT_NAME}-targets
        RUNTIME DESTINATION "${install_prefix}${CMAKE_INSTALL_BINDIR}"
                COMPONENT ${PROJECT_NAME}_Runtime
        LIBRARY DESTINATION "${install_prefix}${CMAKE_INSTALL_LIBDIR}"
                COMPONENT ${PROJECT_NAME}_Runtime
                NAMELINK_COMPONENT ${PROJECT_NAME}_Development
        ARCHIVE DESTINATION "${install_prefix}${CMAKE_INSTALL_LIBDIR}"
                COMPONENT ${PROJECT_NAME}_Development)
    # install(DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/"
    #     DESTINATION "${install_prefix}${CMAKE_INSTALL_INCLUDEDIR}/${tgt_name}"
    #     FILES_MATCHING REGEX ${header_regex})
    install(FILES ${arg_HEADERS}
        DESTINATION "${install_prefix}${CMAKE_INSTALL_INCLUDEDIR}/${tgt_name}")
endfunction()

function(projname_add_executable tgt_name)
    set(options)
    set(one_value_args)
    set(multi_value_args SOURCES DEPENDS)
    cmake_parse_arguments(arg "${options}"
        "${one_value_args}" "${multi_value_args}" ${ARGN})

    add_executable(${tgt_name})
    add_executable(${PROJECT_NAME}::${tgt_name} ALIAS ${tgt_name})
    set_target_properties(${tgt_name}
      PROPERTIES
        VERSION ${PROJECT_VERSION}
    )
    if(UNIX AND NOT APPLE)
        set_target_properties(${tgt_name}
          PROPERTIES
            INSTALL_RPATH "$ORIGIN/../${CMAKE_INSTALL_LIBDIR}"
        )
    endif()
    target_sources(${tgt_name}
      PRIVATE
        ${arg_SOURCES}
    )
    get_filename_component(parent_source_dir "${CMAKE_CURRENT_SOURCE_DIR}" DIRECTORY)
    get_filename_component(parent_binary_dir "${CMAKE_CURRENT_BINARY_DIR}" DIRECTORY)
    target_include_directories(${tgt_name}
      PRIVATE
        ${parent_source_dir}
        ${parent_binary_dir}
    )
    target_link_libraries(${tgt_name}
      PUBLIC
        ${arg_DEPENDS}
    )
    debug_dynamic_dependencies(${tgt_name})

    get_filename_component(parent_source_dir_name "${parent_source_dir}" NAME)
    if("${parent_source_dir_name}" STREQUAL "examples")
        set(install_prefix "${CMAKE_INSTALL_DATAROOTDIR}/${PROJECT_NAME}/examples/")
    endif()
    install(TARGETS ${tgt_name}
        EXPORT ${PROJECT_NAME}-targets
        RUNTIME DESTINATION "${install_prefix}${CMAKE_INSTALL_BINDIR}"
                COMPONENT ${PROJECT_NAME}_Runtime)
endfunction()

function(projname_add_test tgt_name)
    set(options)
    set(one_value_args)
    set(multi_value_args SOURCES DEPENDS EXTRA_ARGS)
    cmake_parse_arguments(arg "${options}"
        "${one_value_args}" "${multi_value_args}" ${ARGN})

    add_executable(${tgt_name})
    target_sources(${tgt_name}
      PRIVATE
        ${arg_SOURCES}
    )
    target_link_libraries(${tgt_name}
      PUBLIC
        ${arg_DEPENDS}
    )
    debug_dynamic_dependencies(${tgt_name})
    string(REPLACE "${PROJECT_SOURCE_DIR}/" "" test_name
        "${CMAKE_CURRENT_SOURCE_DIR}/${tgt_name}"
    )
    add_test(NAME ${test_name} COMMAND ${tgt_name}
        ${arg_EXTRA_ARGS}
    )
endfunction()
