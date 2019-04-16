#include "lockable.hpp"

#include <mutex>
#include <string>

#include <gtest/gtest.h>

namespace {

using namespace example;

TEST(Lockable, lockAndUnlock) {
    Lockable<std::string> s1{"asd"};
    SUCCEED() << "lockable created";
    s1.lock();
    SUCCEED() << "lockable locked";
    Lockable<std::string>::Lock l1{s1, std::adopt_lock};
    SUCCEED() << "lockable adopted";
    EXPECT_EQ("asd", *l1);
    SUCCEED() << "lockable examined";
}

TEST(Lockable, lockAndSwap) {
    Lockable<std::string> s1{"asd"};
    Lockable<std::string> s2{"qwe"};
    SUCCEED() << "lockables created";
    std::lock(s1, s2);
    SUCCEED() << "lockables locked";
    Lockable<std::string>::Lock l1{s1, std::adopt_lock};
    Lockable<std::string>::Lock l2{s2, std::adopt_lock};
    SUCCEED() << "lockables adopted";
    std::swap(*l1, *l2);
    SUCCEED() << "lockables swapped";
    EXPECT_EQ(6u, l1->size() + l2->size());
    SUCCEED() << "lockables examined";
}

}  // namespace
