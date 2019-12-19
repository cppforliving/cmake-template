#include "generated/enum.hpp"

#include <initializer_list>
#include <sstream>
#include <string>

#include <gtest/gtest.h>

namespace {

struct NumberTestParam {
    std::string expected_string;
    my::numbers::Number given_number;
};

struct NumberTest : testing::TestWithParam<NumberTestParam> {};

TEST_P(NumberTest, ostreamOperator) {
    std::ostringstream oss;
    oss << GetParam().given_number;
    EXPECT_EQ(GetParam().expected_string, oss.str());
}

std::initializer_list<NumberTestParam> const NumberTestParams = {
    {"One", my::numbers::Number::One},
    {"Two", my::numbers::Number::Two},
    {"Tree", my::numbers::Number::Tree},
};

INSTANTIATE_TEST_CASE_P(NumberTests,
                        NumberTest,
                        testing::ValuesIn(NumberTestParams));

TEST(NumberTest, ostreamOperatorOutOfRange) {
    NumberTestParam const param = {"?", my::numbers::Number{0xff}};
    std::ostringstream oss;
#ifdef NDEBUG
    oss << param.given_number;
    EXPECT_EQ(param.expected_string, oss.str());
#else
    EXPECT_DEATH(oss << param.given_number, "");
#endif
}

}  // namespace
