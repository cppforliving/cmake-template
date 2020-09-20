#ifndef EXAMPLES_CPPAPI_CPPAPI_HPP_
#define EXAMPLES_CPPAPI_CPPAPI_HPP_

#include <cstdint>
#include <memory>

#include <cppapi/export.h>

namespace cppapi {
namespace detail {

CPPAPI_EXPORT std::int32_t get_123();

CPPAPI_EXPORT std::unique_ptr<std::int32_t> new_int();

}  // namespace detail

/// Allocates std::int32_t 123 on heap and returns its pointer.
CPPAPI_EXPORT std::unique_ptr<std::int32_t> new_int_123();

}  // namespace cppapi

#endif  // EXAMPLES_CPPAPI_CPPAPI_HPP_
