#include "remove_duplicates.hpp"

#include <algorithm>
#include <deque>
#include <gtest/gtest.h>
#include <string>
#include <vector>

using testing::Test;
using testing::Types;

namespace examples {
namespace {

template<typename>
struct RemoveDuplicatesTest : Test {};

using TestContainers = Types<std::string, std::vector<char>, std::deque<char>>;

TYPED_TEST_SUITE(RemoveDuplicatesTest, TestContainers);

TYPED_TEST(RemoveDuplicatesTest, remove_duplicates) {
    auto const expected = {'a', 'b', 'd', 'e', 'f'};
    TypeParam actual = {'d', 'e', 'a', 'd', 'b', 'e', 'e', 'f'};

    remove_duplicates(actual);

    EXPECT_TRUE(std::equal(expected.begin(), expected.end(), actual.begin(), actual.end()));
}

} // namespace
} // namespace examples
