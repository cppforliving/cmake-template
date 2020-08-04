#include "cppapi.hpp"

namespace cppapi {
namespace detail {

int get_123() {
    return 123;
}

int* new_int() {
    return new int;
}

} // namespace detail

int* new_int_123() {
    auto const x = detail::new_int();
    *x = detail::get_123();
    return x;
}

} // namespace cppapi
