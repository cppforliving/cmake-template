find_program(gcovr_command gcovr)
mark_as_advanced(gcovr_command)
if(gcovr_command)
    function(add_gcovr_command coverage_target)
        if(build_coverage STREQUAL html OR build_coverage STREQUAL xml)
            add_custom_command(TARGET ${coverage_target} POST_BUILD
                COMMAND ${gcovr_command} --${build_coverage}
                    $<$<STREQUAL:${build_coverage},html>:--html-details>
                    -r "${PROJECT_SOURCE_DIR}/src"
                    --object-directory="${PROJECT_BINARY_DIR}"
                    -o "${PROJECT_BINARY_DIR}/coverage.${build_coverage}"
                COMMENT "Generating gcovr ${build_coverage} reports")
        elseif(NOT build_coverage STREQUAL "")
            message(FATAL_ERROR "build_coverage=${build_coverage} not supported yet")
        endif()
    endfunction()
    add_gcovr_command(ExperimentalCoverage)
    add_gcovr_command(ContinuousCoverage)
    add_gcovr_command(NightlyCoverage)
endif()
