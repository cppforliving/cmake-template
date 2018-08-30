option(DOXYGEN_SKIP_DOT "If true this module will skip trying to find Dot" OFF)
find_package(Doxygen)
if(DOXYGEN_FOUND)
    configure_file(Doxyfile.in Doxyfile @ONLY)
    add_custom_target(doc
        COMMAND ${DOXYGEN_EXECUTABLE} Doxyfile > Doxygen.log
        COMMENT "Generating ${PROJECT_NAME} documentation")
endif()
