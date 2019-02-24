# Source https://arcanis.me/en/2015/10/17/cppcheck-and-clang-format

file(GLOB_RECURSE format_source_files *.c *.cpp *.h *.hpp)
foreach(source_file ${format_source_files})
    string(FIND ${source_file} /CMakeFiles/ cmake_files_found)
    if(NOT ${cmake_files_found} EQUAL -1)
        list(REMOVE_ITEM format_source_files ${source_file})
    endif()
endforeach()

find_program(clang_format_command clang-format)
mark_as_advanced(clang_format_command)
add_custom_target(format
    COMMAND ${clang_format_command} -i -verbose ${format_source_files}
    COMMENT "Formatting ${PROJECT_NAME} source files")
unset(format_source_files)
