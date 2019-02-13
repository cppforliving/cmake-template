set(build_static_checks "" CACHE STRING
    "Static code analysis tools: clang-tidy, cppcheck, cpplint, iwyu, lwyu.")

if("${build_static_checks}" STREQUAL clang-tidy)
    find_program(CLANG_TIDY_COMMAND clang-tidy)
    mark_as_advanced(CLANG_TIDY_COMMAND)
    set(CMAKE_C_CLANG_TIDY ${CLANG_TIDY_COMMAND}
        -checks=*,-cert-err58-cpp,-cppcoreguidelines-owning-memory,-cppcoreguidelines-special-member-functions,-fuchsia-default-arguments,-hicpp-special-member-functions,-llvm-header-guard,-llvm-include-order,-clang-diagnostic-unused-command-line-argument,-clang-diagnostic-ignored-optimization-argument
        -warnings-as-errors=*
    )
    set(CMAKE_CXX_CLANG_TIDY ${CMAKE_C_CLANG_TIDY})
elseif("${build_static_checks}" STREQUAL cppcheck)
    find_program(CPPCHECK_COMMAND cppcheck)
    mark_as_advanced(CPPCHECK_COMMAND)
    set(CMAKE_C_CPPCHECK ${CPPCHECK_COMMAND}
        --enable=all
    )
    set(CMAKE_CXX_CPPCHECK ${CMAKE_C_CPPCHECK})
elseif("${build_static_checks}" STREQUAL cpplint)
    find_program(CPPLINT_COMMAND cpplint)
    mark_as_advanced(CPPLINT_COMMAND)
    set(CMAKE_C_CPPLINT ${CPPLINT_COMMAND}
        --filter=-legal/copyright
    )
    set(CMAKE_CXX_CPPLINT ${CMAKE_C_CPPLINT})
elseif("${build_static_checks}" STREQUAL iwyu)
    find_program(IWYU_COMMAND iwyu)
    mark_as_advanced(IWYU_COMMAND)
    set(CMAKE_C_INCLUDE_WHAT_YOU_USE ${IWYU_COMMAND}
        -Xiwyu --mapping_file=${PROJECT_SOURCE_DIR}/iwyu.imp
    )
    set(CMAKE_CXX_INCLUDE_WHAT_YOU_USE ${CMAKE_C_INCLUDE_WHAT_YOU_USE})
    if(NOT MSVC)
        list(APPEND CMAKE_CXX_INCLUDE_WHAT_YOU_USE -nostdinc++)
    endif()
elseif("${build_static_checks}" STREQUAL lwyu)
    set(CMAKE_LINK_WHAT_YOU_USE ON)
elseif(NOT "${build_static_checks}" STREQUAL "")
    message(FATAL_ERROR "build_static_checks=${build_static_checks} not supported yet")
endif()
