#ifndef EXAMPLES_CAPICPP_CAPICPP_H_
#define EXAMPLES_CAPICPP_CAPICPP_H_

#include <capicpp/export.h>

#ifdef __cplusplus
extern "C" {
#endif

/// Allocates int 123 on heap and returns its pointer.
CAPICPP_EXPORT int* capicpp_new_int_123(void);

/// Dellocates memory allocated by capicpp_new_int_123().
CAPICPP_EXPORT void capicpp_delete_int_123(int* x);

#ifdef __cplusplus
} // extern "C"
#endif

#endif // EXAMPLES_CAPICPP_CAPICPP_H_
