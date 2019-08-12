set(${PROJECT_NAME}_coverage "" CACHE STRING
    "Build for coverage analysis. Coverage report types: html, xml, lcov-html.")

if(${PROJECT_NAME}_coverage)
    if(MSVC)
        message(FATAL_ERROR "${PROJECT_NAME}_coverage not supported yet for MSVC")
    else()
        string(APPEND CMAKE_C_FLAGS " --coverage -fno-exceptions")
        string(APPEND CMAKE_CXX_FLAGS " --coverage -fno-exceptions")
    endif()
endif()

set(gcovr_coverage_types html xml)
set(lcov_coverage_types lcov-html)
set(coverage_targets ExperimentalCoverage ContinuousCoverage NightlyCoverage)

if(${PROJECT_NAME}_coverage IN_LIST gcovr_coverage_types)
    find_program(gcovr_command gcovr)
    mark_as_advanced(gcovr_command)
    foreach(coverage_target IN LISTS coverage_targets)
        add_custom_command(TARGET ${coverage_target} POST_BUILD
            COMMAND ${CMAKE_COMMAND} -E make_directory coverage
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
                --output coverage/index.${${PROJECT_NAME}_coverage}
                --print-summary
            COMMENT "Generating gcovr-${${PROJECT_NAME}_coverage} report")
    endforeach()
elseif(${PROJECT_NAME}_coverage IN_LIST lcov_coverage_types)
    find_program(lcov_command lcov)
    find_program(genhtml_command genhtml)
    mark_as_advanced(lcov_command genhtml_command)
    foreach(coverage_target IN LISTS coverage_targets)
        add_custom_command(TARGET ${coverage_target} POST_BUILD
            COMMAND ${lcov_command} -q -c -d "${PROJECT_BINARY_DIR}" -b "${PROJECT_SOURCE_DIR}" --no-external -o coverage.info
            COMMAND ${lcov_command} -q -r coverage.info "*/external/*" -o coverage.info
            COMMAND ${lcov_command} -q -r coverage.info "*/tests/*" -o coverage.info
            COMMAND ${lcov_command} -q -r coverage.info "*_test.cpp" -o coverage.info
            COMMAND ${genhtml_command} -o coverage -t ${PROJECT_NAME} --branch-coverage --function-coverage --demangle-cpp coverage.info
            COMMENT "Generating ${${PROJECT_NAME}_coverage} report")
    endforeach()
elseif(NOT ${PROJECT_NAME}_coverage STREQUAL "")
    message(FATAL_ERROR "${PROJECT_NAME}_coverage=${${PROJECT_NAME}_coverage} not supported yet")
endif()
