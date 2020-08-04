#include "capicpp.h"

#include <new>

namespace {

int get_123() {
    return 123;
}

int* new_int() {
    return new (std::nothrow) int;
}

} // namespace

int* capicpp_new_int_123(void) {
    auto const x = new_int();
    *x = get_123();
    return x;
}

void capicpp_delete_int_123(int* const x) {
    delete x;
}
