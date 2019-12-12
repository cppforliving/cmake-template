#ifndef CPPAPI_CPPAPI_HPP
#define CPPAPI_CPPAPI_HPP

#include <cppapi/export.h>

namespace cppapi {
namespace detail {

CPPAPI_EXPORT int get123();

CPPAPI_EXPORT int* newInt();

}  // namespace detail

/**
 * Allocates int 123 on heap and returns its pointer
 */
CPPAPI_EXPORT int* newInt123();

}  // namespace cppapi

#endif  // CPPAPI_CPPAPI_HPP
