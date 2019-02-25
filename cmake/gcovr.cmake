find_program(gcovr_command gcovr)
mark_as_advanced(gcovr_command)

function(add_gcovr_command coverage_target)
    if(${PROJECT_NAME}_coverage STREQUAL html OR ${PROJECT_NAME}_coverage STREQUAL xml)
        add_custom_command(TARGET ${coverage_target} POST_BUILD
            COMMAND ${gcovr_command} --${${PROJECT_NAME}_coverage}
                $<$<STREQUAL:${${PROJECT_NAME}_coverage},html>:--html-details>
                -r "${PROJECT_SOURCE_DIR}/src"
                --object-directory="${PROJECT_BINARY_DIR}"
                -o "${PROJECT_BINARY_DIR}/coverage.${${PROJECT_NAME}_coverage}"
            COMMENT "Generating gcovr ${${PROJECT_NAME}_coverage} reports")
    elseif(NOT ${PROJECT_NAME}_coverage STREQUAL "")
        message(FATAL_ERROR "${PROJECT_NAME}_coverage=${${PROJECT_NAME}_coverage} not supported yet")
    endif()
endfunction()

add_gcovr_command(ExperimentalCoverage)
add_gcovr_command(ContinuousCoverage)
add_gcovr_command(NightlyCoverage)
