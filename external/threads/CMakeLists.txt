option(THREADS_PREFER_PTHREAD_FLAG "Prefer use of the -pthread flag" ON)
find_package(Threads MODULE REQUIRED)
projname_print_target_properties(Threads::Threads)
set_property(TARGET
    Threads::Threads
  PROPERTY
    IMPORTED_GLOBAL TRUE
)
