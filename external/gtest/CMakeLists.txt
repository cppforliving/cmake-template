find_package(GTest MODULE REQUIRED)
set_property(TARGET
    GTest::Main
    GTest::GTest
  PROPERTY
    IMPORTED_GLOBAL TRUE
)

add_library(gtest_main INTERFACE)
target_link_libraries(gtest_main INTERFACE GTest::Main GTest::GTest)
target_compile_definitions(gtest_main
  INTERFACE
    GTEST_LINKED_AS_SHARED_LIBRARY=1
    #GTEST_REMOVE_LEGACY_TEST_CASEAPI_
)
if(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    target_compile_options(gtest_main
      INTERFACE
        -Wno-error=covered-switch-default
        -Wno-error=global-constructors
        -Wno-error=gnu-zero-variadic-macro-arguments
        -Wno-error=used-but-marked-unused
    )
endif()
