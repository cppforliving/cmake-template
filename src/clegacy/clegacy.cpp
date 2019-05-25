#include "clegacy.h"

#include <new>

namespace {

int get123() {
    return 123;
}

int* newInt() {
    return new (std::nothrow) int;
}

}  // namespace

#ifdef __cplusplus
extern "C" {
#endif

int* clegacy_newInt123(void) {
    int* x = newInt();
    *x = get123();
    return x;
}

void clegacy_deleteInt123(int* x) {
    delete x;
}

#ifdef __cplusplus
}  // extern "C"
#endif
