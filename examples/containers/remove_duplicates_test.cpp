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
    TypeParam c = {'d', 'e', 'a', 'd', 'b', 'e', 'e', 'f'};

    remove_duplicates(c);

    auto const no_dups = {'a', 'b', 'd', 'e', 'f'};
    EXPECT_TRUE(std::equal(no_dups.begin(), no_dups.end(), c.begin(), c.end()));
}

} // namespace
} // namespace examples
