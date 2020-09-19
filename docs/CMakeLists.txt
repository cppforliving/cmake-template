include(GNUInstallDirs)

find_package(Doxygen COMPONENTS doxygen dot)
if(TARGET Doxygen::dot)
    get_filename_component(DOXYGEN_DOT_PATH Doxygen::dot DIRECTORY)
    file(TO_NATIVE_PATH "${DOXYGEN_DOT_PATH}" DOXYGEN_DOT_PATH)
endif()
configure_file(Doxyfile.in Doxyfile @ONLY)
add_custom_target(doc
    COMMAND Doxygen::doxygen Doxyfile >doxygen.log
    DEPENDS Doxyfile
    COMMENT "Generating ${PROJECT_NAME} documentation")
add_dependencies(doc Doxygen::doxygen)
install(DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/html"
    DESTINATION "${CMAKE_INSTALL_DOCDIR}"
    OPTIONAL)
