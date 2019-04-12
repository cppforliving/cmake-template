#include "example.hpp"

#include <gmock/gmock.h>
#include <gtest/gtest.h>

namespace {

using namespace example;

using testing::Eq;

TEST(ExampleTest, getValue) {
    ASSERT_THAT(detail::get123(), Eq(123));
}

TEST(ExampleTest, deleteMemory) {
    delete detail::newInt();
}

}  // namespace
