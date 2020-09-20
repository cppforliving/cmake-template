set(${PROJECT_NAME}_check "" CACHE STRING "Static code analysis tool.")
set_property(CACHE ${PROJECT_NAME}_check PROPERTY STRINGS tidy tidy-fix cppcheck lint iwyu lwyu)

if("${${PROJECT_NAME}_check}" MATCHES "^tidy(\-fix)?$")
    set(clang_tidy_name clang-tidy)
    set(clang_tidy_fix ${CMAKE_MATCH_1})
    if(CMAKE_CXX_COMPILER_ID MATCHES "Clang"
        AND CMAKE_CXX_COMPILER MATCHES "\-[1-9][0-9]*$")
        string(APPEND clang_tidy_name ${CMAKE_MATCH_0})
    endif()
    find_program(clang_tidy_command ${clang_tidy_name})
    mark_as_advanced(clang_tidy_command)
    set(CMAKE_CXX_CLANG_TIDY ${clang_tidy_command} ${clang_tidy_fix})
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
elseif("${${PROJECT_NAME}_check}" STREQUAL lint)
    find_program(cpplint_command cpplint)
    mark_as_advanced(cpplint_command)
    set(CMAKE_CXX_CPPLINT ${cpplint_command}
        --filter=-build/c++11,-build/include_order,-build/include_subdir,-legal/copyright,-runtime/references,-whitespace/braces
        --linelength=100
    )
elseif("${${PROJECT_NAME}_check}" STREQUAL iwyu)
    find_program(iwyu_command iwyu)
    mark_as_advanced(iwyu_command)
    set(CMAKE_CXX_INCLUDE_WHAT_YOU_USE ${iwyu_command}
        -Xiwyu --mapping_file=${PROJECT_SOURCE_DIR}/external/asio/iwyu.imp
        -Xiwyu --mapping_file=${PROJECT_SOURCE_DIR}/external/gtest/iwyu.imp
        -Xiwyu --mapping_file=${PROJECT_SOURCE_DIR}/external/pybind11/iwyu.imp
    )
elseif("${${PROJECT_NAME}_check}" STREQUAL lwyu)
    set(CMAKE_LINK_WHAT_YOU_USE ON)
elseif(NOT "${${PROJECT_NAME}_check}" STREQUAL "")
    message(FATAL_ERROR "${PROJECT_NAME}_check=${${PROJECT_NAME}_check} not supported yet")
endif()
