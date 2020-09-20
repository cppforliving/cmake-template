#include "ssize.hpp"

#include <array>
#include <gtest/gtest.h>
#include <map>
#include <string>
#include <vector>

using testing::Test;
using testing::Types;

namespace examples {
namespace {

template<typename>
struct SsizeTest : Test {};

using TestContainers =
    Types<std::string, std::vector<char>, std::map<char, int>, std::array<char, 8>, char[8]>;

TYPED_TEST_SUITE(SsizeTest, TestContainers);

TYPED_TEST(SsizeTest, getContainerSsize) {
    TypeParam c = {};

    auto const s = examples::ssize(c);  // MSVC error C2668

    EXPECT_GE(s, 0);
}

}  // namespace
}  // namespace examples
