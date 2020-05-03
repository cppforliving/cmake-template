set(${PROJECT_NAME}_coverage "" CACHE STRING "Coverage report type.")
set_property(CACHE ${PROJECT_NAME}_coverage PROPERTY STRINGS html xml lcov-html)

if(${PROJECT_NAME}_coverage)
    if(MSVC)
        message(FATAL_ERROR "${PROJECT_NAME}_coverage not supported yet for MSVC")
    else()
        add_compile_options(--coverage)
        add_link_options(--coverage)
    endif()
endif()

set(gcovr_coverage_types html xml)
set(lcov_coverage_types lcov-html)
set(coverage_targets ExperimentalCoverage ContinuousCoverage NightlyCoverage)
set(COVERAGE_EXTRA_FLAGS "${COVERAGE_EXTRA_FLAGS} -b"
    CACHE STRING "Extra command line flags to pass to the coverage tool" FORCE)

if(${PROJECT_NAME}_coverage IN_LIST gcovr_coverage_types)
    find_program(gcovr_command gcovr)
    mark_as_advanced(gcovr_command)
    foreach(coverage_target IN LISTS coverage_targets)
        set(gcovr_options
            --root="${PROJECT_SOURCE_DIR}"
            --exclude-directories="external"
            --exclude-directories="tests"
            --exclude=".*_test\.cpp"
            --exclude=".*_benchmark\.cpp"
            --object-directory="${PROJECT_BINARY_DIR}"
        )
        add_custom_command(TARGET ${coverage_target} POST_BUILD
            COMMAND ${CMAKE_COMMAND} -E make_directory coverage
            COMMAND ${gcovr_command} ${gcovr_options}
            COMMAND ${gcovr_command} ${gcovr_options}
                --branches
            COMMAND ${gcovr_command} ${gcovr_options}
                $<$<STREQUAL:${${PROJECT_NAME}_coverage},xml>:--xml>
                $<$<STREQUAL:${${PROJECT_NAME}_coverage},html>:--html-details>
                $<$<STREQUAL:${${PROJECT_NAME}_coverage},html>:--html-title=${PROJECT_NAME}>
                --output=coverage/index.${${PROJECT_NAME}_coverage}
                --print-summary
            COMMENT "Generating gcovr-${${PROJECT_NAME}_coverage} report")
    endforeach()
elseif(${PROJECT_NAME}_coverage IN_LIST lcov_coverage_types)
    find_program(lcov_command lcov)
    find_program(genhtml_command genhtml)
    mark_as_advanced(lcov_command genhtml_command)
    foreach(coverage_target IN LISTS coverage_targets)
        set(lcov_options
            --output-file=coverage.info
            --rc=lcov_branch_coverage=1
        )
        add_custom_command(TARGET ${coverage_target} POST_BUILD
            COMMAND ${lcov_command} ${lcov_options}
                --quiet
                --capture
                --directory="${PROJECT_BINARY_DIR}"
                --base-directory="${PROJECT_SOURCE_DIR}"
                --no-external
            COMMAND ${lcov_command} ${lcov_options}
                --quiet
                --remove=coverage.info
                    "*/external/*"
                    "*/tests/*"
                    "*_test.cpp"
                    "*_benchmark.cpp"
            COMMAND ${lcov_command} ${lcov_options}
                --list=coverage.info
            COMMAND ${lcov_command} ${lcov_options}
                --summary=coverage.info
            COMMAND ${genhtml_command} coverage.info
                --quiet
                --output-directory=coverage
                --title=${PROJECT_NAME}
                --branch-coverage
                --demangle-cpp
            COMMENT "Generating ${${PROJECT_NAME}_coverage} report")
    endforeach()
elseif(NOT ${PROJECT_NAME}_coverage STREQUAL "")
    message(FATAL_ERROR "${PROJECT_NAME}_coverage=${${PROJECT_NAME}_coverage} not supported yet")
endif()
