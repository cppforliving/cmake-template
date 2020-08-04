#ifndef EXAMPLES_CPPAPI_CPPAPI_HPP_
#define EXAMPLES_CPPAPI_CPPAPI_HPP_

#include <cppapi/export.h>

namespace cppapi {
namespace detail {

CPPAPI_EXPORT int get_123();

CPPAPI_EXPORT int* new_int();

} // namespace detail

/// Allocates int 123 on heap and returns its pointer.
CPPAPI_EXPORT int* new_int_123();

} // namespace cppapi

#endif // EXAMPLES_CPPAPI_CPPAPI_HPP_
