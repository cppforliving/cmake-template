#include "example.hpp"

#include <gmock/gmock.h>
#include <gtest/gtest.h>

namespace {

using testing::Eq;

TEST(Example, getValue) {
    EXPECT_THAT(example::detail::get123(), Eq(123));
}

TEST(Example, deleteMemory) {
    delete example::detail::newInt();
}

}  // namespace
