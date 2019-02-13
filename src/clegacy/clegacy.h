#ifndef CLEGACY_CLEGACY_H_
#define CLEGACY_CLEGACY_H_

#include "clegacy/Config.h"

#ifdef __cplusplus
extern "C" {
#endif

/**
 * Allocates int 123 on heap and returns its pointer
 */
CLEGACY_API int* clegacy_newInt123(void);

#ifdef __cplusplus
}  // extern "C"
#endif

#endif  // CLEGACY_CLEGACY_H_
