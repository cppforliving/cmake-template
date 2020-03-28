#include "ssize.hpp"

#include <gtest/gtest.h>
#include <array>
#include <map>
#include <string>
#include <vector>

namespace ssize {
namespace {

using testing::Test;
using testing::Types;

template <typename T>
struct SsizeTest : Test {};

using SsizeTestContainers = Types<std::string,
                                  std::vector<char>,
                                  std::map<char, int>,
                                  std::array<char, 8>,
                                  char[8]>;

TYPED_TEST_SUITE(SsizeTest, SsizeTestContainers);

TYPED_TEST(SsizeTest, getContainerSsize) {
    TypeParam c = {};
    auto const s = ssize(c);
    EXPECT_GE(s, 0);
}

}  // namespace
}  // namespace ssize
