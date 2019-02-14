find_program(GCOVR_COMMAND gcovr)
mark_as_advanced(GCOVR_COMMAND)
if(GCOVR_COMMAND)
    function(add_gcovr_command coverage_target)
        if(build_coverage STREQUAL html OR build_coverage STREQUAL xml)
            add_custom_command(TARGET ${coverage_target} POST_BUILD
                COMMAND ${CMAKE_COMMAND} -E make_directory test-reports
                COMMAND ${GCOVR_COMMAND} --${build_coverage}
                    $<$<STREQUAL:${build_coverage},html>:--html-details>
                    -r "${PROJECT_SOURCE_DIR}/src"
                    --object-directory="${PROJECT_BINARY_DIR}"
                    -o "${PROJECT_BINARY_DIR}/test-reports/coverage.${build_coverage}"
                COMMENT "Generating gcovr ${build_coverage} reports")
        elseif(NOT build_coverage STREQUAL "")
            message(FATAL_ERROR "build_coverage=${build_coverage} not supported yet")
        endif()
    endfunction()
    add_gcovr_command(ExperimentalCoverage)
    add_gcovr_command(ContinuousCoverage)
    add_gcovr_command(NightlyCoverage)
endif()