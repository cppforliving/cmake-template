include(CMakePrintHelpers)


find_package(Catch2 CONFIG REQUIRED)
cmake_print_properties(
  TARGETS
    Catch2::Catch2
  PROPERTIES
    TYPE
    NAME
    EXPORT_NAME
    EXPORT_PROPERTIES
    IMPORTED
    IMPORTED_CONFIGURATIONS
    INTERFACE_INCLUDE_DIRECTORIES
    INTERFACE_COMPILE_DEFINITIONS
    INTERFACE_COMPILE_OPTIONS
    INTERFACE_LINK_LIBRARIES
    INTERFACE_POSITION_INDEPENDENT_CODE
)
set_property(TARGET
    Catch2::Catch2
  PROPERTY
    IMPORTED_GLOBAL TRUE
)

add_library(catch2_main)
target_sources(catch2_main PRIVATE catch2_main.cpp)
target_link_libraries(catch2_main PUBLIC Catch2::Catch2)
if(MSVC)
    set_property(TARGET catch2_main PROPERTY WINDOWS_EXPORT_ALL_SYMBOLS ON)
else()
    set_property(TARGET catch2_main PROPERTY CXX_VISIBILITY_PRESET default)
endif()
