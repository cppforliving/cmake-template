#include "cppapi.hpp"

#include <gtest/gtest.h>
#include <memory>

namespace cppapi {
namespace {

TEST(cppapi, all) {
    auto const x = newInt123();
    EXPECT_EQ(*x, 123);
    delete x;
}

TEST(cppapi, getValue) {
    EXPECT_EQ(detail::get123(), 123);
}

TEST(cppapi, deleteMemory) {
    delete detail::newInt();
}

}  // namespace
}  // namespace cppapi
