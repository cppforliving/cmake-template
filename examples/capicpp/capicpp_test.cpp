#include "capicpp.h"

#include <gtest/gtest.h>
#include <memory>

namespace {

TEST(capicpp, all) {
    auto const x = capicpp_newInt123();
    EXPECT_EQ(*x, 123);
    capicpp_deleteInt123(x);
}

}  // namespace
