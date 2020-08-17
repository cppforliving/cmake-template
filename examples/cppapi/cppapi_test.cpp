#include "cppapi.hpp"

#include <gmock/gmock.h>
#include <gtest/gtest.h>
#include <memory>

using testing::Eq;

namespace cppapi {
namespace {

TEST(cppapi, all) {
    auto const x = new_int_123();
    EXPECT_THAT(*x, Eq(123));
}

TEST(cppapi, get_value) {
    EXPECT_THAT(detail::get_123(), Eq(123));
}

TEST(cppapi, delete_memory) {
    detail::new_int();
}

} // namespace
} // namespace cppapi
