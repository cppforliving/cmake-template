#include "clegacy.h"

#include <cstdlib>

#include <gmock/gmock.h>
#include <gtest/gtest.h>

namespace {

using testing::Eq;

TEST(Clegacy, all) {
    auto x = clegacy_newInt123();
    EXPECT_THAT(*x, Eq(123));
    free(x);
}

}  // namespace
