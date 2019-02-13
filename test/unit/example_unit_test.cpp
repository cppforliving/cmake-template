#include <gmock/gmock.h>
#include <gtest/gtest.h>
#include "example/example.hpp"

using ::testing::Eq;

TEST(example_unit_test, test) {
    ASSERT_THAT(example::detail::get123(), Eq(123));
}

TEST(example_unit_test, memory) {
    delete example::detail::newInt();
}
