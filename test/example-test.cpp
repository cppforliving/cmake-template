#include <gmock/gmock.h>
#include <gtest/gtest.h>
using namespace ::testing;

TEST(example, test)
{
    ASSERT_THAT(123, Eq(123));
}
