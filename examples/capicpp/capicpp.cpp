#include "capicpp.h"

#include <new>

namespace {

int get123() {
    return 123;
}

int* newInt() {
    return new (std::nothrow) int;
}

}  // namespace

int* capicpp_newInt123(void) {
    int* x = newInt();
    *x = get123();
    return x;
}

void capicpp_deleteInt123(int* const x) {
    delete x;
}
