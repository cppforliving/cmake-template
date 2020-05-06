find_package(GTest MODULE REQUIRED)
projname_print_target_properties(GTest::Main)
projname_print_target_properties(GTest::GTest)
set_property(TARGET
    GTest::Main
    GTest::GTest
  PROPERTY
    IMPORTED_GLOBAL TRUE
)

add_library(gtest_main INTERFACE)
target_link_libraries(gtest_main
  INTERFACE
    GTest::Main
    GTest::GTest
)
target_compile_definitions(gtest_main
  INTERFACE
    GTEST_LINKED_AS_SHARED_LIBRARY=1
    #GTEST_REMOVE_LEGACY_TEST_CASEAPI_
)
if(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    target_compile_options(gtest_main
      INTERFACE
        -Wno-global-constructors
        -Wno-gnu-zero-variadic-macro-arguments
    )
endif()
