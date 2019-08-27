#include "cppapi.hpp"

namespace cppapi {
namespace detail {

int get123() {
    return 123;
}

int* newInt() {
    return new int;
}

}  // namespace detail

int* newInt123() {
    auto const x = detail::newInt();
    *x = detail::get123();
    return x;
}

}  // namespace cppapi
