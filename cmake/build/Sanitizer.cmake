set(sanitizer_type "" CACHE STRING "Sanitizer types: thread, address, leak, memory, undefined.")

if(sanitizer_type)
    if(MSVC)
        message(FATAL_ERROR "sanitizer_type not supported yet for MSVC")
    else()
        add_compile_options(-fsanitize=${sanitizer_type})
    endif()
    if(sanitizer_type STREQUAL thread)
        set(MEMORYCHECK_TYPE ThreadSanitizer)
    elseif(sanitizer_type STREQUAL address)
        set(MEMORYCHECK_TYPE AddressSanitizer)
    elseif(sanitizer_type STREQUAL leak)
        set(MEMORYCHECK_TYPE LeakSanitizer)
    elseif(sanitizer_type STREQUAL memory)
        set(MEMORYCHECK_TYPE MemorySanitizer)
    elseif(sanitizer_type STREQUAL undefined)
        set(MEMORYCHECK_TYPE UndefinedBehaviorSanitizer)
    else()
        message(FATAL_ERROR "sanitizer_type=${sanitizer_type} not supported yet")
    endif()
endif()