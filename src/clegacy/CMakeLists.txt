get_filename_component(lib_name "${CMAKE_CURRENT_SOURCE_DIR}" NAME)
add_library(${lib_name})
target_sources(${lib_name}
  PRIVATE
    clegacy.c
    clegacy.h
    "${CMAKE_CURRENT_BINARY_DIR}/export.h"
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
    add_gtest_test(${lib_name}_test
      SOURCES
        clegacy_test.cpp
      DEPENDS
        ${lib_name}
    )
endif()
