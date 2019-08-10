find_program(gcovr_command gcovr)
mark_as_advanced(gcovr_command)

set(coverage_types html xml)
if(${PROJECT_NAME}_coverage IN_LIST coverage_types)
    foreach(coverage_target ExperimentalCoverage ContinuousCoverage NightlyCoverage)
        add_custom_command(TARGET ${coverage_target} POST_BUILD
            COMMAND ${gcovr_command}
                --root "${PROJECT_SOURCE_DIR}"
                --exclude-directories "external"
                --exclude-directories "tests"
                --exclude ".*_test.cpp"
                --object-directory "${PROJECT_BINARY_DIR}"
                $<$<STREQUAL:${${PROJECT_NAME}_coverage},xml>:--xml>
                $<$<STREQUAL:${${PROJECT_NAME}_coverage},html>:--html-details>
                $<$<STREQUAL:${${PROJECT_NAME}_coverage},html>:--html-title>
                $<$<STREQUAL:${${PROJECT_NAME}_coverage},html>:${PROJECT_NAME}>
                --output "${PROJECT_BINARY_DIR}/coverage.${${PROJECT_NAME}_coverage}"
                --print-summary
            COMMENT "Generating gcovr ${${PROJECT_NAME}_coverage} reports")
    endforeach()
elseif(NOT ${PROJECT_NAME}_coverage STREQUAL "")
    message(FATAL_ERROR "${PROJECT_NAME}_coverage=${${PROJECT_NAME}_coverage} not supported yet")
endif()
