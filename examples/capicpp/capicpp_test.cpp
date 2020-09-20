#include "capicpp.h"

#include <gtest/gtest.h>
#include <memory>

namespace {

TEST(capicpp, all) {
    auto* const x = capicpp_new_int_123();
    EXPECT_EQ(*x, 123);
    capicpp_delete_int_123(x);
}

}  // namespace
