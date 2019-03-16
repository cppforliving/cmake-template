get_filename_component(lib_name "${CMAKE_CURRENT_SOURCE_DIR}" NAME)
set(dll ${lib_name})
string(TOUPPER ${dll} DLL)
configure_file(
    "${PROJECT_SOURCE_DIR}/src/Config.h.in"
    "${CMAKE_CURRENT_BINARY_DIR}/Config.h"
)
add_library(${lib_name}
    clegacy.c
)
target_include_directories(${lib_name}
  PUBLIC
    $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/src>
    $<BUILD_INTERFACE:${PROJECT_BINARY_DIR}/src>
    $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
)
install(TARGETS ${lib_name}
    EXPORT ${PROJECT_NAME}
    DESTINATION "${CMAKE_INSTALL_LIBDIR}")
install(DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/"
    DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}/${lib_name}"
    FILES_MATCHING REGEX "/.*\\.h(h|pp|xx)?$")
install(FILES "${CMAKE_CURRENT_BINARY_DIR}/Config.h"
    DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}/${lib_name}")