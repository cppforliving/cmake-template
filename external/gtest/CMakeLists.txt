find_package(GTest MODULE REQUIRED)
set_target_properties(
    GTest::Main
    GTest::GTest
  PROPERTIES
    IMPORTED_GLOBAL TRUE
)

add_library(gtest_main INTERFACE)
target_link_libraries(gtest_main INTERFACE GTest::Main GTest::GTest)
target_compile_definitions(gtest_main INTERFACE GTEST_LINKED_AS_SHARED_LIBRARY=1)
if(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    target_compile_options(gtest_main
      INTERFACE
        -Wno-error=global-constructors
    )
endif()
