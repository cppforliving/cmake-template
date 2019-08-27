#include "cppapi.hpp"

#include <gmock/gmock.h>
#include <gtest/gtest.h>

namespace {

using testing::Eq;

TEST(Example, getValue) {
    EXPECT_THAT(cppapi::detail::get123(), Eq(123));
}

TEST(Example, deleteMemory) {
    delete cppapi::detail::newInt();
}

}  // namespace
