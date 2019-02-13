set(valgrind_tool memcheck CACHE STRING "Valgrind tools: memcheck, cachegrind, callgrind, massif, helgrind, drd.")

set(VALGRIND_COMMAND_OPTIONS "--tool=${valgrind_tool}")
if(valgrind_tool STREQUAL memcheck)
    string(APPEND VALGRIND_COMMAND_OPTIONS " \
        --leak-check=yes \
        --show-reachable=yes \
        --num-callers=50 \
        --suppressions=${PROJECT_SOURCE_DIR}/valgrind.supp \
        --error-exitcode=1 \
        --read-inline-info=yes \
        --xtree-memory=full \
        --xtree-memory-file=test-reports/memcheck-xtmemory.kcg \
        --child-silent-after-fork=yes \
        --xml=yes \
        --xml-file=test-reports/valgrind.xml")
# cachegrind
elseif(valgrind_tool STREQUAL callgrind)
    string(APPEND VALGRIND_COMMAND_OPTIONS " \
        --dump-instr=yes \
        --collect-jumps=yes \
        --callgrind-out-file=test-reports/callgrind.out")
# helgrind --xtree-memory=full --xtree-memory-file=test-reports/helgrind-xtmemory.kcg
# drd
elseif(valgrind_tool STREQUAL massif)
    string(APPEND VALGRIND_COMMAND_OPTIONS " \
        --xtree-memory=full \
        --xtree-memory-file=test-reports/massif-xtmemory.kcg \
        --massif-out-file=test-reports/massif.out")
else()
    message(FATAL_ERROR "valgrind_tool=${valgrind_tool} not supported yet")
endif()
