include_guard(DIRECTORY)

include(GenerateExportHeader)

include(ProjectUtils)


function(projname_add_library tgt_name)
    projname_parse_arguments(arg "INTERFACE" "" "SOURCES;DEPENDS" ${ARGN})

    set(header_regex ".*\\.h(h|pp|xx|\\+\\+)?$")
    list(TRANSFORM arg_SOURCES
        PREPEND "${CMAKE_CURRENT_SOURCE_DIR}/"
        REGEX "^[^\/][^:].*"
    )
    set(headers ${arg_SOURCES})
    list(FILTER arg_SOURCES EXCLUDE REGEX ${header_regex})
    list(FILTER headers INCLUDE REGEX ${header_regex})

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
        )
        list(APPEND headers "${CMAKE_CURRENT_BINARY_DIR}/export.h")
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
        "$<BUILD_INTERFACE:${headers}>"
    )
    get_filename_component(parent_source_dir "${CMAKE_CURRENT_SOURCE_DIR}" DIRECTORY)
    get_filename_component(parent_binary_dir "${CMAKE_CURRENT_BINARY_DIR}" DIRECTORY)
    target_include_directories(${tgt_name}
      ${visibility}
        $<BUILD_INTERFACE:${parent_source_dir}>
        $<BUILD_INTERFACE:${parent_binary_dir}>
    )
    target_link_libraries(${tgt_name}
      ${visibility}
        ${arg_DEPENDS}
    )
    projname_debug_dynamic_deps(${tgt_name})
    projname_install_target(${tgt_name} HEADERS ${headers})
endfunction()


function(projname_add_executable tgt_name)
    projname_parse_arguments(arg "" "" "SOURCES;DEPENDS" ${ARGN})

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
    projname_debug_dynamic_deps(${tgt_name})
    projname_install_target(${tgt_name})
endfunction()


function(projname_add_test tgt_name)
    projname_parse_arguments(arg "" "" "SOURCES;DEPENDS;EXTRA_ARGS" ${ARGN})

    if(NOT BUILD_TESTING)
        return()
    endif()

    add_executable(${tgt_name})
    target_sources(${tgt_name}
      PRIVATE
        ${arg_SOURCES}
    )
    target_link_libraries(${tgt_name}
      PUBLIC
        ${arg_DEPENDS}
    )
    projname_debug_dynamic_deps(${tgt_name})
    string(REPLACE "${PROJECT_SOURCE_DIR}/" "" test_name
        "${CMAKE_CURRENT_SOURCE_DIR}/${tgt_name}"
    )
    add_test(NAME ${test_name} COMMAND ${tgt_name}
        ${arg_EXTRA_ARGS}
    )
    projname_add_test_labels(${test_name} EXECUTABLE)
    projname_add_test_environent(${test_name})
endfunction()
