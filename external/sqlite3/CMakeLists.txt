find_package(SQLite3 CONFIG)
if(NOT SQLite3_FOUND)
    include("${CMAKE_BINARY_DIR}/conanbuildinfo.cmake" OPTIONAL)
    find_package(SQLite3 MODULE REQUIRED)
endif()
if(TARGET sqlite3)
    set_target_properties(
        sqlite3
      PROPERTIES
        IMPORTED_GLOBAL TRUE
    )
    add_library(SQLite3::SQLite3 ALIAS sqlite3)
elseif(TARGET sqlite3::sqlite3)
    set_target_properties(
        sqlite3::sqlite3
      PROPERTIES
        IMPORTED_GLOBAL TRUE
    )
    add_library(SQLite3::SQLite3 ALIAS sqlite3::sqlite3)
else()
    set_target_properties(
        SQLite3::SQLite3
      PROPERTIES
        IMPORTED_GLOBAL TRUE
    )
endif()
