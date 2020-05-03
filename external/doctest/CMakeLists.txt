find_package(doctest REQUIRED)
projname_print_target_properties(doctest::doctest)
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
