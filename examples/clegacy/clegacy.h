#ifndef CLEGACY_CLEGACY_H
#define CLEGACY_CLEGACY_H

#include <clegacy/export.h>

#ifdef __cplusplus
extern "C" {
#endif

/**
 * Allocates int 123 on heap and returns its pointer
 */
CLEGACY_EXPORT int* clegacy_newInt123(void);

CLEGACY_EXPORT void clegacy_deleteInt123(int* x);

#ifdef __cplusplus
}  // extern "C"
#endif

#endif  // CLEGACY_CLEGACY_H
