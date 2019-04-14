#include "lockable.hpp"

#include <mutex>
#include <string>

#include <gtest/gtest.h>

namespace {

using namespace example;

TEST(LockableTest, lockAndUnlock) {
    Lockable<std::string> s1{"asd"};
    s1.lock();
    Lockable<std::string>::Lock l1{s1, std::adopt_lock};
    EXPECT_EQ("asd", *l1);
}

TEST(LockableTest, lockAndSwap) {
    Lockable<std::string> s1{"asd"};
    Lockable<std::string> s2{"qwe"};
    std::lock(s1, s2);
    Lockable<std::string>::Lock l1{s1, std::adopt_lock};
    Lockable<std::string>::Lock l2{s2, std::adopt_lock};
    std::swap(*l1, *l2);
    EXPECT_EQ(6u, l1->size() + l2->size());
}

}  // namespace
