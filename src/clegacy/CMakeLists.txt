get_filename_component(lib_name "${CMAKE_CURRENT_SOURCE_DIR}" NAME)
add_library(${lib_name})
target_sources(${lib_name}
  PRIVATE
    clegacy.c
)
target_include_directories(${lib_name}
  PUBLIC
    $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/src>
    $<BUILD_INTERFACE:${PROJECT_BINARY_DIR}/src>
    $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
)
include(GenerateExportHeader)
generate_export_header(${lib_name}
    EXPORT_FILE_NAME export.h
)

install(TARGETS ${lib_name}
    EXPORT ${PROJECT_NAME}
    DESTINATION "${CMAKE_INSTALL_LIBDIR}")
install(DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/"
    DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}/${lib_name}"
    FILES_MATCHING REGEX "/.*\\.h(h|pp|xx)?$")
install(FILES "${CMAKE_CURRENT_BINARY_DIR}/export.h"
    DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}/${lib_name}")

if(BUILD_TESTING)
    set(test_name ${lib_name}_test)
    add_executable(${test_name})
    target_sources(${test_name}
      PRIVATE
        clegacy_test.cpp
    )
    target_link_libraries(${test_name}
      PRIVATE
        GTest::Main
        GTest::GTest
        ${lib_name}
    )
    target_compile_definitions(${test_name}
      PRIVATE
        GTEST_LINKED_AS_SHARED_LIBRARY=1
    )
    if(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
        target_compile_options(${test_name}
          PRIVATE
            -Wno-error=global-constructors
            -Wno-error=zero-as-null-pointer-constant
        )
    endif()
    debug_dynamic_dependencies(${test_name})
    add_test(NAME ${test_name} COMMAND ${test_name}
        --gtest_color=yes
        --gtest_output=xml:${test_name}.xml
    )
endif()
