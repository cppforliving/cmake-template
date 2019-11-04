#include "cppapi.hpp"

#include <memory>

#include <gmock/gmock.h>
#include <gtest/gtest.h>

namespace {

using testing::Eq;

TEST(cppapi, all) {
    auto const x = cppapi::newInt123();
    EXPECT_THAT(*x, Eq(123));
    delete x;
}

TEST(cppapi, getValue) {
    EXPECT_THAT(cppapi::detail::get123(), Eq(123));
}

TEST(cppapi, deleteMemory) {
    delete cppapi::detail::newInt();
}

}  // namespace
