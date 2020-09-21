find_package(spdlog REQUIRED)
projname_print_target_properties(
    spdlog::spdlog
    spdlog::libspdlog
    fmt::fmt
)
set_property(TARGET
    spdlog::spdlog
    fmt::fmt
  PROPERTY
    IMPORTED_GLOBAL TRUE
)
