find_package(spdlog REQUIRED)
set_property(TARGET
    spdlog::spdlog
  PROPERTY
    IMPORTED_GLOBAL TRUE
)
