target_sources(examples_test
  PRIVATE
    parallel_test.cpp
)

target_link_libraries(examples_test
  PUBLIC
    TBB::tbb
)
