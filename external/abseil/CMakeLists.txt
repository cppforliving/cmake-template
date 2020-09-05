find_package(absl REQUIRED)
if(NOT TARGET absl::absl)
    add_library(absl::absl INTERFACE IMPORTED)
    set_target_properties(absl::absl PROPERTIES INTERFACE_LINK_LIBRARIES absl::span)
endif()
projname_print_target_properties(absl::absl absl::span)
set_property(TARGET
    absl::absl
  PROPERTY
    IMPORTED_GLOBAL TRUE
)
