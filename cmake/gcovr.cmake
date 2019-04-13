find_program(gcovr_command gcovr)
mark_as_advanced(gcovr_command)

if(${PROJECT_NAME}_coverage STREQUAL html OR ${PROJECT_NAME}_coverage STREQUAL xml)
    foreach(coverage_target ExperimentalCoverage ContinuousCoverage NightlyCoverage)
        add_custom_command(TARGET ${coverage_target} POST_BUILD
            COMMAND ${gcovr_command}
                --root "${PROJECT_SOURCE_DIR}/src"
                --exclude ".*_test.cpp"
                --object-directory "${PROJECT_BINARY_DIR}"
                $<$<STREQUAL:${${PROJECT_NAME}_coverage},xml>:--xml>
                $<$<STREQUAL:${${PROJECT_NAME}_coverage},html>:--html-details>
                --output "${PROJECT_BINARY_DIR}/coverage.${${PROJECT_NAME}_coverage}"
                --print-summary
            COMMENT "Generating gcovr ${${PROJECT_NAME}_coverage} reports")
    endforeach()
elseif(NOT ${PROJECT_NAME}_coverage STREQUAL "")
    message(FATAL_ERROR "${PROJECT_NAME}_coverage=${${PROJECT_NAME}_coverage} not supported yet")
endif()
