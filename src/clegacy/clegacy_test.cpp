#include "clegacy.h"

#include <cstdlib>

#include <gmock/gmock.h>
#include <gtest/gtest.h>

namespace {

using testing::Eq;

TEST(ClegacyTest, all) {
    auto x = clegacy_newInt123();
    ASSERT_THAT(*x, Eq(123));
    free(x);
}

}  // namespace
