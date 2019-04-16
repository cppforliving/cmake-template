#include "lockable.hpp"

#include <mutex>
#include <string>

#include <gtest/gtest.h>

namespace {

using namespace example;

TEST(Lockable, lockAndUnlock) {
    Lockable<std::string> s1{"asd"};
    SUCCESS() << "lockable created";
    s1.lock();
    SUCCESS() << "lockable locked";
    Lockable<std::string>::Lock l1{s1, std::adopt_lock};
    SUCCESS() << "lockable adopted";
    EXPECT_EQ("asd", *l1);
    SUCCESS() << "lockable examined";
}

TEST(Lockable, lockAndSwap) {
    Lockable<std::string> s1{"asd"};
    Lockable<std::string> s2{"qwe"};
    SUCCESS() << "lockables created";
    std::lock(s1, s2);
    SUCCESS() << "lockables locked";
    Lockable<std::string>::Lock l1{s1, std::adopt_lock};
    Lockable<std::string>::Lock l2{s2, std::adopt_lock};
    SUCCESS() << "lockables adopted";
    std::swap(*l1, *l2);
    SUCCESS() << "lockables swapped";
    EXPECT_EQ(6u, l1->size() + l2->size());
    SUCCESS() << "lockables examined";
}

}  // namespace
