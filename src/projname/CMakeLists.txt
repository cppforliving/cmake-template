cmade_cxx_add_library(projname
  SOURCES
    lockable.hpp
    projname.cpp
    projname.hpp
  DEPENDS
    Threads::Threads
    asio::asio
    Boost::date_time
    Boost::diagnostic_definitions
    Boost::disable_autolinking
    Boost::dynamic_linking
)

cmade_cxx_add_executable(projname_tool
  SOURCES
    projname_main.cpp
  DEPENDS
    projname
)

cmade_py_add_module(pyprojname
  SOURCES
    projname_py.cpp
  DEPENDS
    projname
)

cmade_cxx_add_test(projname_test
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
    cmade_cxx_add_test(projname_benchmark
      SOURCES
        lockable_benchmark.cpp
      DEPENDS
        projname
        benchmark_main
    )
endif()
