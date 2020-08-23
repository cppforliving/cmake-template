#include "capicpp.h"

#include <gmock/gmock.h>
#include <gtest/gtest.h>
#include <memory>

using testing::Eq;

namespace {

TEST(capicpp, all) {
    auto* const x = capicpp_new_int_123();
    EXPECT_THAT(*x, Eq(123));
    capicpp_delete_int_123(x);
}

} // namespace
