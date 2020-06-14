find_package(benchmark REQUIRED)
projname_print_target_properties(benchmark::benchmark_main)
projname_print_target_properties(benchmark::benchmark)
set_property(TARGET
    benchmark::benchmark_main
    benchmark::benchmark
  PROPERTY
    IMPORTED_GLOBAL TRUE
)

add_library(benchmark_main INTERFACE)
target_link_libraries(benchmark_main
  INTERFACE
    benchmark::benchmark_main
    benchmark::benchmark
)
if(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    target_compile_options(benchmark_main
      INTERFACE
        -Wno-global-constructors
    )
endif()
