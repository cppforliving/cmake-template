include(CMakePrintHelpers)


find_package(doctest REQUIRED)
cmake_print_properties(
  TARGETS
    doctest::doctest
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
    doctest::doctest
  PROPERTY
    IMPORTED_GLOBAL TRUE
)

add_library(doctest_main)
target_sources(doctest_main PRIVATE doctest_main.cpp)
target_link_libraries(doctest_main PUBLIC doctest::doctest)
if(MSVC)
    set_property(TARGET doctest_main PROPERTY WINDOWS_EXPORT_ALL_SYMBOLS ON)
else()
    set_property(TARGET doctest_main PROPERTY CXX_VISIBILITY_PRESET default)
endif()
