#include "clegacy.h"

#include <gmock/gmock.h>
#include <gtest/gtest.h>
#include <stdlib.h>

namespace clegacy_test {

using testing::Eq;

TEST(clegacy, all) {
    auto x = clegacy_newInt123();
    ASSERT_THAT(*x, Eq(123));
    free(x);
}

}  // namespace clegacy_test
