#include "example.hpp"

#include <gmock/gmock.h>
#include <gtest/gtest.h>

namespace example {
namespace test {

using testing::Eq;

TEST(example, test) {
    ASSERT_THAT(detail::get123(), Eq(123));
}

TEST(example, memory) {
    delete detail::newInt();
}

}  // namespace test
}  // namespace example
