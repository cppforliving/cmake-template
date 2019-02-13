# Source https://arcanis.me/en/2015/10/17/cppcheck-and-clang-format

# additional target to perform clang-format run, requires clang-format

# get all project files
file(GLOB_RECURSE ALL_SOURCE_FILES *.cpp *.hpp)
foreach(SOURCE_FILE ${ALL_SOURCE_FILES})
    string(FIND ${SOURCE_FILE} /CMakeFiles/ CMAKE_FILES_DIR_FOUND)
    if(NOT ${CMAKE_FILES_DIR_FOUND} EQUAL -1)
        list(REMOVE_ITEM ALL_SOURCE_FILES ${SOURCE_FILE})
    endif()
endforeach()

find_program(CLANG_FORMAT_COMMAND clang-format)
mark_as_advanced(CLANG_FORMAT_COMMAND)
add_custom_target(clang-format
    COMMAND ${CLANG_FORMAT_COMMAND} -i ${ALL_SOURCE_FILES}
    COMMENT "Running clang-format on ${PROJECT_NAME}")
