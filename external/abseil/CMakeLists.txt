find_package(absl REQUIRED)
projname_print_target_properties(absl::absl)
set_property(TARGET
    absl::absl
  PROPERTY
    IMPORTED_GLOBAL TRUE
)
