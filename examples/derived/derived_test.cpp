#include "derived.hpp"

#include <memory>
#include <new>
#include <type_traits>

#include <gtest/gtest.h>

namespace {

TEST(Derived, stackDestruction) {
    std::aligned_storage_t<sizeof(derived::Derived)> storage;
    derived::Base* base = new (&storage) derived::Derived{};
    base->~Base();
}

TEST(Derived, callVirtualMethod) {
    auto const derived = std::make_unique<derived::Derived>();
    EXPECT_NO_FATAL_FAILURE(derived->virtualMethod());
}

TEST(Derived, callProtectedMethod) {
    struct TestDerived : derived::Derived {
        int publicMethod() { return protectedMethod(); }
    };
    TestDerived test_derived;
    EXPECT_NO_FATAL_FAILURE(test_derived.publicMethod());
}

}  // namespace
