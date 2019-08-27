#include "lockable.hpp"

#include <mutex>
#include <string>
#include <type_traits>

#include <gtest/gtest.h>

namespace {

using namespace std::string_literals;

TEST(Lockable, lockAndUnlockManually) {
    projname::Lockable<std::string> s1;
    s1.lock();
    s1.unlock();
}

TEST(Lockable, lockGuard) {
    projname::Lockable s1{"asd"s};
    EXPECT_TRUE(
        (std::is_same_v<projname::Lockable<std::string>, decltype(s1)>));

    projname::Lock l1{s1};
    EXPECT_TRUE((std::is_same_v<projname::Lock<projname::Lockable<std::string>>,
                                decltype(l1)>));

    EXPECT_EQ("asd", *l1);
    EXPECT_EQ(3u, l1->size());
}

TEST(Lockable, initializeByCopy) {
    auto s0{"qwe"s};
    projname::Lockable s1{s0};
    EXPECT_TRUE(
        (std::is_same_v<projname::Lockable<std::string>, decltype(s1)>));

    projname::Lock l1{s1};
    EXPECT_TRUE((std::is_same_v<projname::Lock<projname::Lockable<std::string>>,
                                decltype(l1)>));

    *l1 = "asd";
    EXPECT_EQ("qwe", s0);
    EXPECT_EQ("asd", *l1);
}

TEST(Lockable, lockAndSwap) {
    projname::Lockable s1{"asd"s};
    projname::Lockable s2{"qwe"s};
    std::lock(s1, s2);
    projname::Lock l1{s1, std::adopt_lock};
    projname::Lock l2{s2, std::adopt_lock};
    std::swap(*l1, *l2);
    EXPECT_EQ(6u, l1->size() + l2->size());
}

}  // namespace
