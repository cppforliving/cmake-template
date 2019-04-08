#include "Derived.hpp"

#include <gtest/gtest.h>

namespace example {
namespace test {

TEST(Derived, virtualMethod) {
    Derived derived;
    ASSERT_NO_THROW(derived.virtualMethod());
}

}  // namespace test
}  // namespace example
