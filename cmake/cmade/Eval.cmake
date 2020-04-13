include_guard(DIRECTORY)

include(CMakePrintHelpers)


macro(cmade_eval)
    execute_process(COMMAND ${ARGN} RESULT_VARIABLE ret)
    if(ret)
        string(REPLACE ";" " " msg "'${ARGN}' failed with error code ${ret}")
        message(FATAL_ERROR "${msg}")
    endif()
endmacro()


macro(cmade_eval_out out)
    cmade_eval(${ARGN} OUTPUT_STRIP_TRAILING_WHITESPACE OUTPUT_VARIABLE ${out})
    cmake_print_variables(${out})
endmacro()
