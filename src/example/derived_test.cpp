#include "derived.hpp"

#include <gtest/gtest.h>

namespace {

using namespace example;

TEST(Derived, callVirtualMethod) {
    Derived derived;
    EXPECT_NO_THROW(derived.virtualMethod());
}

}  // namespace
