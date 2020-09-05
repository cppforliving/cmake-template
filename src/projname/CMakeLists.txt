projname_add_library(projname
  SOURCES
    lockable.hpp
    projname.cpp
    projname.hpp
  DEPENDS
    Threads::Threads
    absl::absl
    asio::asio
    spdlog::spdlog
)

projname_add_executable(projname_tool
  SOURCES
    projname_main.cpp
  DEPENDS
    projname
)

projname_add_pymodule(pyprojname
  SOURCES
    projname_py.cpp
  DEPENDS
    projname
)

projname_add_test(projname_test
  SOURCES
    lockable_test.cpp
    projname_test.cpp
  DEPENDS
    projname
    gtest_main
  EXTRA_ARGS
    --gtest_color=yes
)

if(BUILD_BENCHMARKS)
    projname_add_test(projname_benchmark
      SOURCES
        lockable_benchmark.cpp
      DEPENDS
        projname
        benchmark_main
    )
endif()

if(BUILD_FUZZERS)
    projname_add_test(projname_fuzzer
      SOURCES
        projname_fuzzer.cpp
      DEPENDS
        projname
        absl::absl
      EXTRA_ARGS
        -max_total_time=${BUILD_FUZZERS}
    )
endif()
