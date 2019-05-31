find_package(GTest MODULE REQUIRED)
set_target_properties(
    GTest::Main
    GTest::GTest
  PROPERTIES
    IMPORTED_GLOBAL TRUE
)

add_library(gtest_main INTERFACE)
target_link_libraries(gtest_main INTERFACE GTest::Main GTest::GTest)
if(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    target_compile_options(gtest_main
      INTERFACE
        -Wno-global-constructors
        -Wno-gnu-zero-variadic-macro-arguments
        -Wno-zero-as-null-pointer-constant
    )
endif()
