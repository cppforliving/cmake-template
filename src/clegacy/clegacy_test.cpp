#include "clegacy.h"

#include <gmock/gmock.h>
#include <gtest/gtest.h>
#include <stdlib.h>

namespace {

using testing::Eq;

TEST(ClegacyTest, all) {
    auto x = clegacy_newInt123();
    ASSERT_THAT(*x, Eq(123));
    free(x);
}

}  // namespace
