set(${PROJECT_NAME}_check "" CACHE STRING
    "Static code analysis tools: clang-tidy, cppcheck, cpplint, iwyu, lwyu.")

if("${${PROJECT_NAME}_check}" STREQUAL clang-tidy)
    find_program(clang_tidy_command clang-tidy)
    mark_as_advanced(clang_tidy_command)
    set(CMAKE_CXX_CLANG_TIDY ${clang_tidy_command})
elseif("${${PROJECT_NAME}_check}" STREQUAL cppcheck)
    find_program(cppcheck_command cppcheck)
    mark_as_advanced(cppcheck_command)
    set(CMAKE_CXX_CPPCHECK ${cppcheck_command}
        --enable=warning,performance,portability,information,missingInclude
        --error-exitcode=1
        --library=${PROJECT_SOURCE_DIR}/external/catch2/cppcheck.cfg
        --library=${PROJECT_SOURCE_DIR}/external/gtest/cppcheck.cfg
        --suppress=missingIncludeSystem
    )
elseif("${${PROJECT_NAME}_check}" STREQUAL cpplint)
    find_program(cpplint_command cpplint)
    mark_as_advanced(cpplint_command)
    set(CMAKE_CXX_CPPLINT ${cpplint_command}
        --filter=-build/c++11,-build/include_order,-build/include_subdir,-legal/copyright,-runtime/references,-whitespace/braces
    )
elseif("${${PROJECT_NAME}_check}" STREQUAL iwyu)
    find_program(iwyu_command iwyu)
    mark_as_advanced(iwyu_command)
    set(CMAKE_CXX_INCLUDE_WHAT_YOU_USE ${iwyu_command}
        -Xiwyu --mapping_file=${PROJECT_SOURCE_DIR}/external/boost/iwyu.imp
        -Xiwyu --mapping_file=${PROJECT_SOURCE_DIR}/external/gtest/iwyu.imp
    )
elseif("${${PROJECT_NAME}_check}" STREQUAL lwyu)
    set(CMAKE_LINK_WHAT_YOU_USE ON)
elseif(NOT "${${PROJECT_NAME}_check}" STREQUAL "")
    message(FATAL_ERROR "${PROJECT_NAME}_check=${${PROJECT_NAME}_check} not supported yet")
endif()
