#ifndef EXAMPLES_CPPAPI_CPPAPI_HPP_
#define EXAMPLES_CPPAPI_CPPAPI_HPP_

#include <examples/export.h>

namespace cppapi {
namespace detail {

EXAMPLES_EXPORT int get123();

EXAMPLES_EXPORT int* newInt();

}  // namespace detail

/// Allocates int 123 on heap and returns its pointer.
EXAMPLES_EXPORT int* newInt123();

}  // namespace cppapi

#endif  // EXAMPLES_CPPAPI_CPPAPI_HPP_
