find_package(span-lite REQUIRED)
if(NOT TARGET span-lite::span-lite)
    add_library(span-lite::span-lite INTERFACE IMPORTED)
    set_target_properties(span-lite::span-lite
      PROPERTIES
         INTERFACE_LINK_LIBRARIES nonstd::span-lite
    )
endif()
projname_print_target_properties(span-lite::span-lite nonstd::span-lite)
set_property(TARGET
    span-lite::span-lite
  PROPERTY
    IMPORTED_GLOBAL TRUE
)
