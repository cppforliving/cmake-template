cmake_minimum_required(VERSION 3.12)
message(STATUS "CMake version: ${CMAKE_VERSION}")

option(BUILD_SHARED_LIBS
    "Global flag to cause `add_library()` to create shared libraries if on." ON)
option(CMAKE_EXPORT_COMPILE_COMMANDS
    "Enable/Disable output of compile commands during generation." ON)
option(CMAKE_INTERPROCEDURAL_OPTIMIZATION
    "Enable interprocedural optimization if supported by the compiler." OFF)

project(projname
    VERSION 0.1
    DESCRIPTION "CMake & Conan based template for C/C++ projects."
    LANGUAGES C CXX)

if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
    set(CMAKE_INSTALL_PREFIX "${CMAKE_BINARY_DIR}/dist" CACHE PATH
        "Install path prefix, prepended onto install directories." FORCE)
endif()

set(CMAKE_SKIP_RPATH OFF)
set(CMAKE_MACOSX_RPATH OFF)

list(APPEND CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/cmake")
include("${CMAKE_BINARY_DIR}/conan_paths.cmake")
#list(INSERT CMAKE_MODULE_PATH 0 "${CMAKE_BINARY_DIR}")

set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS OFF)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ${CMAKE_C_STANDARD_REQUIRED})
set(CMAKE_CXX_EXTENSIONS ${CMAKE_C_EXTENSIONS})

set(CMAKE_C_VISIBILITY_PRESET hidden)
set(CMAKE_CXX_VISIBILITY_PRESET ${CMAKE_C_VISIBILITY_PRESET})
set(CMAKE_VISIBILITY_INLINES_HIDDEN ON)

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib")
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin")
set(CMAKE_PDB_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin")

#string(APPEND CMAKE_C_FLAGS " -Wl,--as-needed -Wl,--no-undefined")
#string(APPEND CMAKE_CXX_FLAGS " -Wl,--as-needed -Wl,--no-undefined")

find_package(Threads MODULE REQUIRED)
set(Boost_NO_SYSTEM_PATHS ON)
find_package(Boost MODULE REQUIRED COMPONENTS system date_time)

include(GNUInstallDirs)
include(Diagnostics)
include(Valgrind)
include(uninstall)
include(CTest)
if(BUILD_TESTING)
    find_package(GTest MODULE REQUIRED)
    find_package(Catch2 CONFIG REQUIRED)
    #include(download/googletest)
    #include(download/benchmark)
    #include(download/Catch2)
endif()
#include(download/abseil-cpp)
#include(download/GSL)
find_package(GSL MODULE REQUIRED)
include(Warnings)
include(format)
include(StaticChecks)
include(Sanitizers)
include(Coverage)
include(gcovr)
include(Profiling)

include(ProjectHelpers)

add_subdirectory(src)

include(CMakePackageConfigHelpers)
write_basic_package_version_file(
    "${CMAKE_CURRENT_BINARY_DIR}/cmake/${PROJECT_NAME}ConfigVersion.cmake"
    VERSION ${PROJECT_VERSION}
    COMPATIBILITY AnyNewerVersion
)

export(EXPORT ${PROJECT_NAME}Targets
    NAMESPACE ${PROJECT_NAME}::
    FILE "${CMAKE_CURRENT_BINARY_DIR}/cmake/${PROJECT_NAME}Targets.cmake"
)
configure_package_config_file(
    "${CMAKE_CURRENT_SOURCE_DIR}/cmake/Config.cmake.in"
    "${CMAKE_CURRENT_BINARY_DIR}/cmake/${PROJECT_NAME}Config.cmake"
    INSTALL_DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}"
)

option(CMAKE_EXPORT_NO_PACKAGE_REGISTRY "Disable the export(PACKAGE) command." ON)
export(PACKAGE ${PROJECT_NAME})

install(EXPORT ${PROJECT_NAME}Targets
    NAMESPACE ${PROJECT_NAME}::
    DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}"
)
install(FILES
    "${CMAKE_CURRENT_BINARY_DIR}/cmake/${PROJECT_NAME}Config.cmake"
    "${CMAKE_CURRENT_BINARY_DIR}/cmake/${PROJECT_NAME}ConfigVersion.cmake"
    DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}"
)

if(BUILD_TESTING)
    add_subdirectory(test)
endif()

add_subdirectory(doc)

#unset(CONAN_FOUND_LIBRARY CACHE)
