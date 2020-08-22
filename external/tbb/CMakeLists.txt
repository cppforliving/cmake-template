find_package(TBB REQUIRED)
if(NOT TARGET TBB::tbb)
    add_library(TBB::tbb INTERFACE IMPORTED)
    set_property(TARGET TBB::tbb
      PROPERTY INTERFACE_LINK_LIBRARIES TBB::TBB
    )
endif()
set_property(TARGET
    TBB::tbb
    #TBB::tbbmalloc
    #TBB::tbbmalloc_proxy
  PROPERTY
    IMPORTED_GLOBAL TRUE
)
