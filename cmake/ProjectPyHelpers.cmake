include_guard(DIRECTORY)

include(ProjectUtils)


function(projname_add_pymodule tgt_name)
    projname_parse_arguments(arg "MODULE" "" "SOURCES;DEPENDS" ${ARGN})  # TODO SHARED

#    if(arg_SHARED)
#        list(APPEND arg_UNPARSED_ARGUMENTS SHARED)
#    endif()
    if(arg_MODULE)
        list(APPEND arg_UNPARSED_ARGUMENTS MODULE)
    endif()

    pybind11_add_module(${tgt_name} SYSTEM ${arg_SOURCES} ${arg_UNPARSED_ARGUMENTS})
    add_library(${PROJECT_NAME}::${tgt_name} ALIAS ${tgt_name})
    set_property(TARGET ${tgt_name} PROPERTY CXX_STANDARD 14)  # pybind11 issue (std::align_val_t)
    if(UNIX)
        if(NOT APPLE)
            set_target_properties(${tgt_name}
                PROPERTIES INSTALL_RPATH "$ORIGIN"  # TODO move to utils
            )
        endif()
        target_compile_options(${tgt_name} PRIVATE -Wno-error=missing-prototypes)
    endif()
    target_link_libraries(${tgt_name}
        PUBLIC ${arg_DEPENDS}
        PRIVATE pybind11::module
    )
    projname_debug_dynamic_deps(${tgt_name})
    projname_install_target(${tgt_name})
endfunction()


function(projname_prepend_test_environment_path test_name path_name prefix_dir)
    projname_parse_arguments(arg "" "" "" ${ARGN})

    if(WIN32)
        set(path_delim ";")
    else()
        set(path_delim ":")
    endif()
    get_property(generator_is_multi_config
        GLOBAL PROPERTY GENERATOR_IS_MULTI_CONFIG)
    if(generator_is_multi_config)
        string(APPEND prefix_dir "/$<CONFIG>")
    endif()
    file(TO_NATIVE_PATH "${prefix_dir}" prefix_dir)
    set(path_value "${prefix_dir}${path_delim}$ENV{${path_name}}")
    string(REPLACE ";" "\\;" path_value "${path_value}")
    set_property(TEST ${test_name} APPEND PROPERTY ENVIRONMENT "${path_name}=${path_value}")
endfunction()


function(projname_add_pytest tgt_name)
    projname_parse_arguments(arg "" "" "SOURCES;DEPENDS" ${ARGN})

    if(NOT BUILD_TESTING)
        return()
    endif()

    set(extensions)
    foreach(tgt_name IN LISTS arg_DEPENDS)
        get_target_property(tgt_type ${tgt_name} TYPE)
        if(tgt_type STREQUAL "MODULE_LIBRARY" OR tgt_type STREQUAL "SHARED_LIBRARY")
            list(APPEND extensions ${tgt_name})
        endif()
    endforeach()
    string(REPLACE ";" "," extensions "${extensions}")
    if(${PROJECT_NAME}_check STREQUAL "lint")
        set(test_driver pylint)
        set(test_driver_args --extension-pkg-whitelist=${extensions})
    else()
        set(test_driver pytest)
    endif()
#    file(GENERATE OUTPUT ${tgt_name}_runner.py
#        CONTENT "from os import system\nsystem('${PYTHON_EXECUTABLE} -m ${test_command} ${CMAKE_CURRENT_SOURCE_DIR}/${arg_SOURCES}\')\n")
#    add_custom_target(${tgt_name}_runner.py
#        COMMAND ${PYTHON_EXECUTABLE} ${CMAKE_CURRENT_BINARY_DIR}/${tgt_name}_runner.py
#        SOURCES ${arg_SOURCES}
#        DEPENDS ${tgt_name}_runner.py
#    )
#    add_dependencies(${tgt_name}_runner.py ${arg_DEPENDS})
    set(test_file "${CMAKE_CURRENT_SOURCE_DIR}/${tgt_name}")
    string(REPLACE "${PROJECT_SOURCE_DIR}/" "" test_name "${test_file}")
    add_test(NAME ${test_name}
        COMMAND ${PYTHON_EXECUTABLE} -m ${test_driver} ${test_driver_args} ${test_file}
        WORKING_DIRECTORY "${PROJECT_SOURCE_DIR}"
    )
    string(TOUPPER "${test_driver}" test_driver_upper)
    projname_add_test_labels(${test_name} ${test_driver_upper})
    projname_prepend_test_environment_path(${test_name} PYTHONPATH "${CMAKE_LIBRARY_OUTPUT_DIRECTORY}")
    if(WIN32)
        projname_prepend_test_environment_path(${test_name} PATH "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}")
    endif()
    projname_add_test_environent(${test_name}
        SANITIZER_NO_DETECT_LEAKS
        SANITIZER_PRELOAD_RUNTIME
    )
endfunction()
