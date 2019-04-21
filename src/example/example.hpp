#ifndef EXAMPLE_EXAMPLE_HPP
#define EXAMPLE_EXAMPLE_HPP

#include <example/export.h>

namespace example {
namespace detail {

EXAMPLE_EXPORT int get123();

EXAMPLE_EXPORT int* newInt();

}  // namespace detail

/**
 * Allocates int 123 on heap and returns its pointer
 */
EXAMPLE_EXPORT int* newInt123();

}  // namespace example

#endif  // EXAMPLE_EXAMPLE_HPP
