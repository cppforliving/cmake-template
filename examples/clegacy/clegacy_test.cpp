#include "clegacy.h"

#include <memory>

#include <gmock/gmock.h>
#include <gtest/gtest.h>

namespace {

using testing::Eq;

TEST(clegacy, all) {
    auto const x = clegacy_newInt123();
    EXPECT_THAT(*x, Eq(123));
    clegacy_deleteInt123(x);
}

}  // namespace
