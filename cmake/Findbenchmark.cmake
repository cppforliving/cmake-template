include(FindPackageHandleStandardArgs)


find_library(benchmark_LIBRARY
    NAMES benchmark
    PATH_SUFFIXES lib)

find_library(benchmark_main_LIBRARY
    NAMES benchmark_main
    PATH_SUFFIXES lib)

find_path(benchmark_INCLUDE_DIR
    NAMES benchmark/benchmark.h
    PATH_SUFFIXES include)

find_package_handle_standard_args(benchmark
    FOUND_VAR benchmark_FOUND
    REQUIRED_VARS benchmark_LIBRARY benchmark_main_LIBRARY benchmark_INCLUDE_DIR)

if(benchmark_FOUND)
    if(NOT TARGET benchmark::benchmark)
        add_library(benchmark::benchmark INTERFACE IMPORTED)
        target_link_libraries(benchmark::benchmark
            INTERFACE ${benchmark_LIBRARY})
        target_include_directories(benchmark::benchmark
            INTERFACE ${benchmark_INCLUDE_DIR})
    endif()

    if(NOT TARGET benchmark::benchmark_main)
        add_library(benchmark::benchmark_main INTERFACE IMPORTED)
        target_link_libraries(benchmark::benchmark_main
            INTERFACE ${benchmark_main_LIBRARY} benchmark::benchmark)
    endif()

    set(benchmark_LIBRARIES ${benchmark_LIBRARY})
    set(benchmark_main_LIBRARIES ${benchmark_main_LIBRARY})
    set(benchmark_INCLUDE_DIRS ${benchmark_INCLUDE_DIR})
endif()

mark_as_advanced(benchmark_LIBRARY benchmark_main_LIBRARY benchmark_INCLUDE_DIR)
