find_package(Threads MODULE REQUIRED)
set_target_properties(
    Threads::Threads
  PROPERTIES
    IMPORTED_GLOBAL TRUE
)
