#ifndef CAPICPP_CAPICPP_H
#define CAPICPP_CAPICPP_H

#include <capicpp/export.h>

#ifdef __cplusplus
extern "C" {
#endif

/**
 * Allocates int 123 on heap and returns its pointer
 */
CAPICPP_EXPORT int* capicpp_newInt123(void);

CAPICPP_EXPORT void capicpp_deleteInt123(int*);

#ifdef __cplusplus
}  // extern "C"
#endif

#endif  // CAPICPP_CAPICPP_H
