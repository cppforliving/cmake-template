#include "clegacy.h"

#include <cstdlib>

#ifdef __cplusplus
extern "C" {
#endif

static int get123(void) {
    return 123;
}

static int* newInt(void) {
    return static_cast<int*>(std::malloc(sizeof(int)));
}

int* clegacy_newInt123(void) {
    int* x = newInt();
    *x = get123();
    return x;
}

void clegacy_deleteInt123(int* x) {
    std::free(x);
}

#ifdef __cplusplus
}  // extern "C"
#endif
