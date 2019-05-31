find_package(GTest MODULE REQUIRED)
get_target_property(gtest_gtest_type GTest::GTest TYPE)
message(STATUS "GTest::GTest TYPE: ${gtest_gtest_type}")
get_target_property(gtest_ifcdefs GTest::GTest INTERFACE_COMPILE_DEFINITIONS)
message(STATUS "GTest::GTest INTERFACE_COMPILE_DEFINITIONS: ${gtest_ifcdefs}")
set_target_properties(
    GTest::Main
    GTest::GTest
  PROPERTIES
    IMPORTED_GLOBAL TRUE
)

get_target_property(gtest_gtest_type GTest::GTest TYPE)
message(STATUS "GTest::GTest TYPE: ${gtest_gtest_type}")
get_target_property(gtest_ifcdefs GTest::GTest INTERFACE_COMPILE_DEFINITIONS)
message(STATUS "GTest::GTest INTERFACE_COMPILE_DEFINITIONS: ${gtest_ifcdefs}")

add_library(gtest_main INTERFACE)
target_link_libraries(gtest_main INTERFACE GTest::Main GTest::GTest)
set_target_properties(GTest::GTest PROPERTIES
    INTERFACE_COMPILE_DEFINITIONS GTEST_LINKED_AS_SHARED_LIBRARY=1)
if(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    target_compile_options(gtest_main
      INTERFACE
        -Wno-global-constructors
        -Wno-gnu-zero-variadic-macro-arguments
        -Wno-zero-as-null-pointer-constant
    )
endif()
