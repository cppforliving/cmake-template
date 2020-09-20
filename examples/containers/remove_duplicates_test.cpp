#include "remove_duplicates.hpp"

#include <deque>
#include <gmock/gmock.h>
#include <gtest/gtest.h>
#include <string>
#include <vector>

using testing::ElementsAre;
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

    EXPECT_THAT(c, ElementsAre('a', 'b', 'd', 'e', 'f'));
}

}  // namespace
}  // namespace examples
