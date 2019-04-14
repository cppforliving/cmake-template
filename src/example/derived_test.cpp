#include "derived.hpp"

#include <gtest/gtest.h>

namespace {

using namespace example;

TEST(DerivedTest, callVirtualMethod) {
    Derived derived;
    EXPECT_NO_THROW(derived.virtualMethod());
}

}  // namespace
