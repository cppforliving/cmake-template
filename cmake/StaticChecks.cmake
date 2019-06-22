set(${PROJECT_NAME}_check "" CACHE STRING
    "Static code analysis tools: clang-tidy, cppcheck, cpplint, iwyu, lwyu.")

if("${${PROJECT_NAME}_check}" STREQUAL clang-tidy)
    find_program(clang_tidy_command clang-tidy)
    mark_as_advanced(clang_tidy_command)
    set(CMAKE_C_CLANG_TIDY ${clang_tidy_command}
        -checks=*,-cert-err58-cpp,-cppcoreguidelines-owning-memory,-cppcoreguidelines-special-member-functions,-fuchsia-default-arguments,-hicpp-special-member-functions,-llvm-header-guard,-llvm-include-order,-clang-diagnostic-unused-command-line-argument,-clang-diagnostic-ignored-optimization-argument,-readability-implicit-bool-conversion,-fuchsia-overloaded-operator,-cppcoreguidelines-no-malloc,-hicpp-no-malloc
        -warnings-as-errors=*
    )
    set(CMAKE_CXX_CLANG_TIDY ${CMAKE_C_CLANG_TIDY})
elseif("${${PROJECT_NAME}_check}" STREQUAL cppcheck)
    find_program(cppcheck_command cppcheck)
    mark_as_advanced(cppcheck_command)
    set(CMAKE_C_CPPCHECK ${cppcheck_command}
        --enable=all
        --check-config
    )
    set(CMAKE_CXX_CPPCHECK ${CMAKE_C_CPPCHECK})
elseif("${${PROJECT_NAME}_check}" STREQUAL cpplint)
    find_program(cpplint_command cpplint)
    mark_as_advanced(cpplint_command)
    set(CMAKE_C_CPPLINT ${cpplint_command}
        --filter=-legal/copyright
    )
    set(CMAKE_CXX_CPPLINT ${CMAKE_C_CPPLINT})
elseif("${${PROJECT_NAME}_check}" STREQUAL iwyu)
    find_program(iwyu_command iwyu)
    mark_as_advanced(iwyu_command)
    set(CMAKE_C_INCLUDE_WHAT_YOU_USE ${iwyu_command}
        -Xiwyu --mapping_file=${PROJECT_SOURCE_DIR}/data/iwyu.imp
    )
    set(CMAKE_CXX_INCLUDE_WHAT_YOU_USE ${CMAKE_C_INCLUDE_WHAT_YOU_USE})
elseif("${${PROJECT_NAME}_check}" STREQUAL lwyu)
    set(CMAKE_LINK_WHAT_YOU_USE ON)
elseif(NOT "${${PROJECT_NAME}_check}" STREQUAL "")
    message(FATAL_ERROR "${PROJECT_NAME}_check=${${PROJECT_NAME}_check} not supported yet")
endif()
