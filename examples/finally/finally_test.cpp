#include "finally.hpp"

#include <gtest/gtest.h>
#include <string>
#include <type_traits>

using testing::Test;
using testing::Types;

namespace examples {
namespace {

constexpr auto stateless_lambda = [] {};
constexpr auto nothrow_move_constructible_lambda = [_ = 0] { (void)_; };
[[maybe_unused]] auto make_copy_constructible_lambda() {
    return [_ = std::string{}] { (void)_; };
}

using FinalActionTypes = Types<
    void (*)(),
    decltype(stateless_lambda),
    decltype(nothrow_move_constructible_lambda),
    decltype(make_copy_constructible_lambda())>;

template<typename>
struct FinallyTest : Test {};

template<typename F>
using FinalAction = decltype(finally(std::declval<F>()));

TYPED_TEST_SUITE(FinallyTest, FinalActionTypes);

TYPED_TEST(FinallyTest, is_not_default_constructible) {
    EXPECT_FALSE(std::is_default_constructible_v<FinalAction<TypeParam>>);
}

TYPED_TEST(FinallyTest, is_nothrow_destructible) {
    EXPECT_TRUE(std::is_nothrow_destructible_v<FinalAction<TypeParam>>);
}

TYPED_TEST(FinallyTest, is_not_copy_constructible) {
    EXPECT_FALSE(std::is_copy_constructible_v<FinalAction<TypeParam>>);
}

TYPED_TEST(FinallyTest, is_not_move_constructible) {
    EXPECT_FALSE(std::is_move_constructible_v<FinalAction<TypeParam>>);
}

TYPED_TEST(FinallyTest, is_nothrow_copy_constructible) {
    auto const expected = std::is_nothrow_copy_constructible_v<std::decay_t<TypeParam>>;
    EXPECT_EQ(
        expected, noexcept(finally<std::decay_t<TypeParam>>(std::declval<TypeParam const>())));
    EXPECT_EQ(expected, noexcept(finally(std::declval<TypeParam const>())));
}

TYPED_TEST(FinallyTest, is_nothrow_move_constructible) {
    auto const expected = std::is_nothrow_move_constructible_v<std::decay_t<TypeParam>>;
    EXPECT_EQ(expected, noexcept(finally<std::decay_t<TypeParam>>(std::declval<TypeParam>())));
    EXPECT_EQ(expected, noexcept(finally(std::declval<TypeParam>())));
}

}  // namespace
}  // namespace examples
