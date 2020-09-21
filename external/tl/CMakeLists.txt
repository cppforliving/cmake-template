find_package(tl-expected REQUIRED)
projname_print_target_properties(tl::expected)
set_property(TARGET
    tl::expected
  PROPERTY
    IMPORTED_GLOBAL TRUE
)

find_package(tl-optional REQUIRED)
projname_print_target_properties(tl::optional)
set_property(TARGET
    tl::optional
  PROPERTY
    IMPORTED_GLOBAL TRUE
)
