#include "derived.hpp"

#include <gtest/gtest.h>
#include <memory>
#include <new>
#include <type_traits>

namespace derived {
namespace {

TEST(Derived, stackDestruction) {
    std::aligned_storage_t<sizeof(Derived)> storage;
    Base* base = new (&storage) Derived{};
    base->~Base();
}

TEST(Derived, callVirtualMethod) {
    auto const derived = std::make_unique<Derived>();
    EXPECT_NO_FATAL_FAILURE(derived->virtualMethod());
}

TEST(Derived, callProtectedMethod) {
    struct TestDerived : Derived {
        static int publicMethod() {
            return protectedMethod();
        }
    };
    EXPECT_NO_FATAL_FAILURE(TestDerived::publicMethod());
}

}  // namespace
}  // namespace derived
