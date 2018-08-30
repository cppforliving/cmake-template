#include <gmock/gmock.h>
#include <gtest/gtest.h>
using namespace ::testing;

TEST(example, test)
{
    ASSERT_THAT(123, Eq(123));
}

TEST(example, memory)
{
    auto x = new int;
    (void)x;
}
