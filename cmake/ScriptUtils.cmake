include_guard(DIRECTORY)

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
