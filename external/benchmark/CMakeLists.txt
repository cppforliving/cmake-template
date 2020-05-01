find_package(benchmark REQUIRED)
set_property(TARGET
    benchmark::benchmark_main
    benchmark::benchmark
  PROPERTY
    IMPORTED_GLOBAL TRUE
)
set_property(TARGET
    benchmark::benchmark_main
    benchmark::benchmark
  APPEND PROPERTY
    INSTALL_RPATH "${CONAN_BENCHMARK_ROOT}/lib"
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
        -Wno-error=global-constructors
    )
endif()
