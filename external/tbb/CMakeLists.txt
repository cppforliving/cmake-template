find_package(TBB REQUIRED)
set_property(TARGET
    TBB::tbb
    #TBB::tbbmalloc
    #TBB::tbbmalloc_proxy
  PROPERTY
    IMPORTED_GLOBAL TRUE
)
