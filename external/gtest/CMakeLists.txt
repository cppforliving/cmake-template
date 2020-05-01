include(CMakePrintHelpers)


find_package(GTest MODULE REQUIRED)
cmake_print_properties(
  TARGETS
    GTest::Main
    GTest::GTest
  PROPERTIES
    TYPE
    NAME
    EXPORT_NAME
    EXPORT_PROPERTIES
    IMPORTED
    IMPORTED_CONFIGURATIONS
    IMPORTED_LOCATION
    INTERFACE_INCLUDE_DIRECTORIES
    INTERFACE_COMPILE_DEFINITIONS
    INTERFACE_COMPILE_OPTIONS
    INTERFACE_LINK_LIBRARIES
    INTERFACE_POSITION_INDEPENDENT_CODE
)
set_property(TARGET
    GTest::Main
    GTest::GTest
  PROPERTY
    IMPORTED_GLOBAL TRUE
)
# set_property(TARGET
#     GTest::Main
#     GTest::GTest
#   APPEND PROPERTY
#     INSTALL_RPATH "${CONAN_GTEST_ROOT}/lib"
# )

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
