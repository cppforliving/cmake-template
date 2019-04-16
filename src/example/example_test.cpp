#include "example.hpp"

#include <gmock/gmock.h>
#include <gtest/gtest.h>

namespace {

using namespace example;

using testing::Eq;

TEST(Example, getValue) {
    EXPECT_THAT(detail::get123(), Eq(123));
}

TEST(Example, deleteMemory) {
    delete detail::newInt();
}

}  // namespace
