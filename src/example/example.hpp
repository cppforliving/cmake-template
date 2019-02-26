#ifndef EXAMPLE_EXAMPLE_HPP_
#define EXAMPLE_EXAMPLE_HPP_

#include "example/Config.h"

namespace example {
namespace detail {

EXAMPLE_API int get123();

EXAMPLE_API int* newInt();

}  // namespace detail

/**
 * Allocates int 123 on heap and returns its pointer
 */
EXAMPLE_API int* newInt123();

}  // namespace example

#endif  // EXAMPLE_EXAMPLE_HPP_
