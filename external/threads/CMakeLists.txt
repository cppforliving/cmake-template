option(THREADS_PREFER_PTHREAD_FLAG "Prefer use of the -pthread flag" ON)
find_package(Threads MODULE REQUIRED)
set_target_properties(
    Threads::Threads
  PROPERTIES
    IMPORTED_GLOBAL TRUE
)
