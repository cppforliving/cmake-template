#include "capicpp.h"

#include <gmock/gmock.h>
#include <gtest/gtest.h>

namespace {

using testing::Eq;

TEST(capicpp, all) {
    auto x = capicpp_newInt123();
    EXPECT_THAT(*x, Eq(123));
    capicpp_deleteInt123(x);
}

}  // namespace
