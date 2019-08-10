#include "derived.hpp"

#include <gtest/gtest.h>

namespace {

TEST(Derived, callVirtualMethod) {
    example::Derived derived;
    EXPECT_NO_FATAL_FAILURE(derived.virtualMethod());
}

TEST(Derived, callProtectedMethod) {
    struct TestDerived : example::Derived {
        int publicMethod() { return protectedMethod(); }
    };
    TestDerived test_derived;
    EXPECT_NO_FATAL_FAILURE(test_derived.publicMethod());
}

}  // namespace
