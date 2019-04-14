set(${PROJECT_NAME}_valgrind memcheck CACHE STRING
    "Valgrind tools: memcheck, cachegrind, callgrind, massif, helgrind, drd.")

list(APPEND VALGRIND_COMMAND_OPTIONS
    --tool=${${PROJECT_NAME}_valgrind})
if(${PROJECT_NAME}_valgrind STREQUAL memcheck)
    list(APPEND VALGRIND_COMMAND_OPTIONS
        --leak-check=yes
        --show-reachable=yes
        --num-callers=50
        --suppressions=${PROJECT_SOURCE_DIR}/data/valgrind.supp
        --error-exitcode=1
        --read-inline-info=yes
        --xtree-memory=full
        --xtree-memory-file=memcheck-xtmemory.kcg
        --child-silent-after-fork=yes
        --xml=yes
        --xml-file=valgrind.xml)
# cachegrind
elseif(${PROJECT_NAME}_valgrind STREQUAL callgrind)
    list(APPEND VALGRIND_COMMAND_OPTIONS
        --dump-instr=yes
        --collect-jumps=yes
        --callgrind-out-file=callgrind.out)
# helgrind --xtree-memory=full --xtree-memory-file=helgrind-xtmemory.kcg
# drd
elseif(${PROJECT_NAME}_valgrind STREQUAL massif)
    list(APPEND VALGRIND_COMMAND_OPTIONS
        --xtree-memory=full
        --xtree-memory-file=massif-xtmemory.kcg
        --massif-out-file=massif.out)
else()
    message(FATAL_ERROR "${PROJECT_NAME}_valgrind=${${PROJECT_NAME}_valgrind} not supported yet")
endif()
string(REPLACE ";" " " VALGRIND_COMMAND_OPTIONS "${VALGRIND_COMMAND_OPTIONS}")
