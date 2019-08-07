#include "lockable.hpp"

#include <mutex>
#include <string>

#include <gtest/gtest.h>

namespace {

TEST(Lockable, lockAndUnlockManually) {
    example::Lockable<std::string> s1{"asd"};
    s1.lock();
    s1.unlock();
}

TEST(Lockable, lockGuard) {
    example::Lockable<std::string> s1{"asd"};
    example::Lockable<std::string>::Lock l1{s1};
    EXPECT_EQ("asd", *l1);
}

TEST(Lockable, initializeByCopy) {
    std::string s0{"qwe"};
    example::Lockable<std::string> s1{s0};
    example::Lockable<std::string>::Lock l1{s1};
    *l1 = "asd";
    EXPECT_EQ("qwe", s0);
    EXPECT_EQ("asd", *l1);
}

TEST(Lockable, lockAndSwap) {
    example::Lockable<std::string> s1{"asd"};
    example::Lockable<std::string> s2{"qwe"};
    std::lock(s1, s2);
    example::Lockable<std::string>::Lock l1{s1, std::adopt_lock};
    example::Lockable<std::string>::Lock l2{s2, std::adopt_lock};
    std::swap(*l1, *l2);
    EXPECT_EQ(6u, l1->size() + l2->size());
}

}  // namespace
