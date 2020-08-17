#include "cppapi.hpp"

namespace cppapi {
namespace detail {

std::int32_t get_123() {
    return 123;
}

std::int32_t* new_int() {
    return new std::int32_t;
}

} // namespace detail

std::int32_t* new_int_123() {
    auto const x = detail::new_int();
    *x = detail::get_123();
    return x;
}

} // namespace cppapi
