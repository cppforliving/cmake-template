#include "ssize.hpp"

#include <array>
#include <string>
#include <vector>

#include <gtest/gtest.h>

namespace {

template <typename T>
struct SsizeTest : testing::Test {};

using SsizeTestContainers = testing::
    Types<std::string, std::vector<char>, std::array<char, 8>, char[8]>;

TYPED_TEST_CASE(SsizeTest, SsizeTestContainers);

TYPED_TEST(SsizeTest, getContainerSsize) {
    TypeParam c = {};
    auto s = ssize::ssize(c);
    EXPECT_TRUE(s >= 0);
}

}  // namespace
