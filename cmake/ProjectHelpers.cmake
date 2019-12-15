include_guard(GLOBAL)

include(GNUInstallDirs)
include(GenerateExportHeader)

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
    set(options INTERFACE)
    set(one_value_args)
    set(multi_value_args SOURCES DEPENDS)
    cmake_parse_arguments(${lib_name} "${options}"
        "${one_value_args}" "${multi_value_args}" ${ARGN})

    set(header_regex ".+\\.h(h|pp|xx|\\+\\+)?$")
    set(${lib_name}_HEADERS ${${lib_name}_SOURCES})
    list(FILTER ${lib_name}_SOURCES EXCLUDE REGEX ${header_regex})
    list(FILTER ${lib_name}_HEADERS INCLUDE REGEX ${header_regex})

    if(${lib_name}_INTERFACE)
        set(lib_type INTERFACE)
        set(visibility INTERFACE)
    else()
        set(visibility PUBLIC)
    endif()

    add_library(${lib_name} ${lib_type})
    add_library(${PROJECT_NAME}::${lib_name} ALIAS ${lib_name})
    if(NOT ${lib_name}_INTERFACE)
        generate_export_header(${lib_name}
            EXPORT_FILE_NAME export.h
            DEFINE_NO_DEPRECATED
        )
        list(APPEND ${lib_name}_HEADERS "${CMAKE_CURRENT_BINARY_DIR}/export.h")
        set_target_properties(${lib_name} ${lib_type}
          PROPERTIES
            SOVERSION ${PROJECT_VERSION_MAJOR}
            VERSION ${PROJECT_VERSION}
        )
        if(UNIX AND NOT APPLE)
            set_target_properties(${lib_name} ${lib_type}
              PROPERTIES
                INSTALL_RPATH "$ORIGIN"
            )
        endif()
        target_sources(${lib_name} ${lib_type}
          PRIVATE
            ${${lib_name}_SOURCES}
          # FIXME Target INTERFACE_SOURCES property contains path which is prefixed in the source/build directory.
          # ${visibility}
            ${${lib_name}_HEADERS}
        )
    endif()
    get_filename_component(parent_source_dir "${CMAKE_CURRENT_SOURCE_DIR}" DIRECTORY)
    get_filename_component(parent_binary_dir "${CMAKE_CURRENT_BINARY_DIR}" DIRECTORY)
    target_include_directories(${lib_name} ${lib_type}
      ${visibility}
        $<BUILD_INTERFACE:${parent_source_dir}>
        $<BUILD_INTERFACE:${parent_binary_dir}>
        $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
    )
    target_link_libraries(${lib_name} ${lib_type}
      ${visibility}
        ${${lib_name}_DEPENDS}
    )
    if(NOT ${lib_name}_INTERFACE)
        debug_dynamic_dependencies(${lib_name})
    endif()

    get_filename_component(parent_source_dir_name "${parent_source_dir}" NAME)
    if("${parent_source_dir_name}" STREQUAL "examples")
        set(install_prefix "${CMAKE_INSTALL_DATAROOTDIR}/${PROJECT_NAME}/examples/")
    endif()
    install(TARGETS ${lib_name}
        EXPORT ${PROJECT_NAME}-targets
        RUNTIME DESTINATION "${install_prefix}${CMAKE_INSTALL_BINDIR}"
                COMPONENT ${PROJECT_NAME}_Runtime
        LIBRARY DESTINATION "${install_prefix}${CMAKE_INSTALL_LIBDIR}"
                COMPONENT ${PROJECT_NAME}_Runtime
                NAMELINK_COMPONENT ${PROJECT_NAME}_Development
        ARCHIVE DESTINATION "${install_prefix}${CMAKE_INSTALL_LIBDIR}"
                COMPONENT ${PROJECT_NAME}_Development)
    # install(DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/"
    #     DESTINATION "${install_prefix}${CMAKE_INSTALL_INCLUDEDIR}/${lib_name}"
    #     FILES_MATCHING REGEX ${header_regex})
    install(FILES ${${lib_name}_HEADERS}
        DESTINATION "${install_prefix}${CMAKE_INSTALL_INCLUDEDIR}/${lib_name}")
endfunction()

function(add_custom_executable exe_name)
    set(options)
    set(one_value_args)
    set(multi_value_args SOURCES DEPENDS)
    cmake_parse_arguments(${exe_name} "${options}"
        "${one_value_args}" "${multi_value_args}" ${ARGN})

    add_executable(${exe_name}_app)
    add_executable(${PROJECT_NAME}::${exe_name}_app ALIAS ${exe_name}_app)
    set_target_properties(${exe_name}_app
      PROPERTIES
        OUTPUT_NAME ${exe_name}
        VERSION ${PROJECT_VERSION}
    )
    if(UNIX AND NOT APPLE)
        set_target_properties(${exe_name}_app
          PROPERTIES
            INSTALL_RPATH "$ORIGIN/../${CMAKE_INSTALL_LIBDIR}"
        )
    endif()
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
    if("${parent_source_dir_name}" STREQUAL "examples")
        set(install_prefix "${CMAKE_INSTALL_DATAROOTDIR}/${PROJECT_NAME}/examples/")
    endif()
    install(TARGETS ${exe_name}_app
        EXPORT ${PROJECT_NAME}-targets
        RUNTIME DESTINATION "${install_prefix}${CMAKE_INSTALL_BINDIR}"
                COMPONENT ${PROJECT_NAME}_Runtime)
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
