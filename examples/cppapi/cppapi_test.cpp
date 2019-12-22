#include "cppapi.hpp"

#include <gmock/gmock.h>
#include <gtest/gtest.h>
#include <memory>

namespace cppapi {
namespace {

using testing::Eq;

TEST(cppapi, all) {
    auto const x = newInt123();
    EXPECT_THAT(*x, Eq(123));
    delete x;
}

TEST(cppapi, getValue) {
    EXPECT_THAT(detail::get123(), Eq(123));
}

TEST(cppapi, deleteMemory) {
    delete detail::newInt();
}

}  // namespace
}  // namespace cppapi
