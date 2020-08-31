#include "capicpp.h"

#include <new>

namespace {

int32_t get_123() {
    return 123;
}

int32_t* new_int() {
    return new (std::nothrow) int32_t;
}

} // namespace

int32_t* capicpp_new_int_123(void) {
    auto* const x = new_int();
    *x = get_123();
    return x;
}

void capicpp_delete_int_123(int32_t* const x) { // NOLINT(readability-non-const-parameter)
    delete x;
}
