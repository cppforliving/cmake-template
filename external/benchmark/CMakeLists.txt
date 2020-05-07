find_package(benchmark REQUIRED)
if(TARGET benchmark::benchmark_main)
    projname_print_target_properties(benchmark::benchmark_main)
    set_property(TARGET
        benchmark::benchmark_main
      PROPERTY
        IMPORTED_GLOBAL TRUE
    )
endif()
projname_print_target_properties(benchmark::benchmark)
set_property(TARGET
    benchmark::benchmark
  PROPERTY
    IMPORTED_GLOBAL TRUE
)

add_library(benchmark_main INTERFACE)
target_link_libraries(benchmark_main
  INTERFACE
    $<TARGET_NAME_IF_EXISTS:benchmark::benchmark_main>
    benchmark::benchmark
)
if(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    target_compile_options(benchmark_main
      INTERFACE
        -Wno-error=global-constructors
    )
endif()
