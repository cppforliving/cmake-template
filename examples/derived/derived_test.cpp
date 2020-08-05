#include "derived.hpp"

#include <gtest/gtest.h>
#include <memory>
#include <new>
#include <type_traits>

namespace derived {
namespace {

TEST(Derived, stack_destruction) {
    std::aligned_storage_t<sizeof(Derived)> storage;
    Base* base = new (&storage) Derived{};
    base->~Base();
}

TEST(Derived, call_virtual_method) {
    auto const derived = std::make_unique<Derived>();
    EXPECT_NO_FATAL_FAILURE(derived->virtual_method());
}

TEST(Derived, call_protected_method) {
    struct TestDerived : Derived {
        int public_method() {
            return protected_method();
        }
    };
    TestDerived test_derived;
    EXPECT_NO_FATAL_FAILURE(test_derived.public_method());
}

} // namespace
} // namespace derived
