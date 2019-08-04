#include "derived.hpp"

#include <gtest/gtest.h>

namespace {

TEST(Derived, callVirtualMethod) {
    example::Derived derived;
    EXPECT_NO_THROW(derived.virtualMethod());
}

}  // namespace
