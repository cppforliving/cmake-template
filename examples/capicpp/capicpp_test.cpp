#include "capicpp.h"

#include <gmock/gmock.h>
#include <gtest/gtest.h>
#include <memory>

namespace {

using testing::Eq;

TEST(capicpp, all) {
    auto const x = capicpp_newInt123();
    EXPECT_THAT(*x, Eq(123));
    capicpp_deleteInt123(x);
}

}  // namespace
