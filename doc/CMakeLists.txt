option(DOXYGEN_SKIP_DOT "If true this module will skip trying to find Dot" OFF)
find_package(Doxygen)
if(DOXYGEN_FOUND)
    get_filename_component(DOXYGEN_DOT_PATH ${DOXYGEN_DOT_EXECUTABLE} DIRECTORY)
    file(TO_NATIVE_PATH ${DOXYGEN_DOT_PATH} DOXYGEN_DOT_PATH)
    configure_file(Doxyfile.in Doxyfile @ONLY)
    add_custom_target(doc
        COMMAND ${DOXYGEN_EXECUTABLE} Doxyfile > Doxygen.log
        COMMENT "Generating ${PROJECT_NAME} documentation")
endif()
