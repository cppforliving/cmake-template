include_guard(GLOBAL)

include(GNUInstallDirs)
include(CMakePackageConfigHelpers)


function(_cmade_install_package)
    write_basic_package_version_file(
        "${PROJECT_BINARY_DIR}/cmake/${PROJECT_NAME}-config-version.cmake"
        VERSION ${PROJECT_VERSION}
        COMPATIBILITY SameMajorVersion
    )
    configure_package_config_file(
        "${CMAKE_CURRENT_LIST_DIR}/package-config.cmake.in"
        "${PROJECT_BINARY_DIR}/cmake/${PROJECT_NAME}-config.cmake"
        INSTALL_DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}"
        NO_SET_AND_CHECK_MACRO
        NO_CHECK_REQUIRED_COMPONENTS_MACRO
    )

    install(EXPORT ${PROJECT_NAME}-targets
        NAMESPACE ${PROJECT_NAME}::
        DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}"
    )
    install(FILES
        "${PROJECT_BINARY_DIR}/cmake/${PROJECT_NAME}-config.cmake"
        "${PROJECT_BINARY_DIR}/cmake/${PROJECT_NAME}-config-version.cmake"
        DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}"
    )
endfunction()


_cmade_install_package()
