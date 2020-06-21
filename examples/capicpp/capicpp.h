#ifndef EXAMPLES_CAPICPP_CAPICPP_H_
#define EXAMPLES_CAPICPP_CAPICPP_H_

#include <examples/export.h>

#ifdef __cplusplus
extern "C" {
#endif

/// Allocates int 123 on heap and returns its pointer.
EXAMPLES_EXPORT int* capicpp_newInt123(void);

/// Dellocates memory allocated by capicpp_newInt123().
EXAMPLES_EXPORT void capicpp_deleteInt123(int* x);

#ifdef __cplusplus
}  // extern "C"
#endif

#endif  // EXAMPLES_CAPICPP_CAPICPP_H_
