#include "cppapi.hpp"

#include <gtest/gtest.h>
#include <memory>

namespace cppapi {
namespace {

TEST(cppapi, all) {
    auto const x = new_int_123();
    EXPECT_EQ(*x, 123);
}

TEST(cppapi, get_value) {
    EXPECT_EQ(detail::get_123(), 123);
}

TEST(cppapi, delete_memory) {
    detail::new_int();
}

}  // namespace
}  // namespace cppapi
