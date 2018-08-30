#include <gmock/gmock.h>
#include <gtest/gtest.h>
#include "example/example.hpp"
using namespace ::testing;

TEST(example, test)
{
    ASSERT_THAT(get123(), Eq(123));
}

TEST(example, memory)
{
    newInt();
}
