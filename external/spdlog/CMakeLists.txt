find_package(spdlog REQUIRED)
set_property(TARGET
    spdlog::spdlog
    fmt::fmt
  PROPERTY
    IMPORTED_GLOBAL TRUE
)
