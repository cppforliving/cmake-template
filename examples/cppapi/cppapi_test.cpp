#include "cppapi.hpp"

#include <gmock/gmock.h>
#include <gtest/gtest.h>
#include <memory>

using testing::Eq;

namespace cppapi {
namespace {

TEST(cppapi, all) {
    auto const x = std::unique_ptr<int>{new_int_123()};
    EXPECT_THAT(*x, Eq(123));
}

TEST(cppapi, getValue) {
    EXPECT_THAT(detail::get_123(), Eq(123));
}

TEST(cppapi, deleteMemory) {
    std::unique_ptr<int>{detail::new_int()};
}

} // namespace
} // namespace cppapi
