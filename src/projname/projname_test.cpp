#include "projname.hpp"

#include <exception>
#include <new>

#include <gtest/gtest.h>

namespace {

using testing::TestWithParam;
using testing::ValuesIn;

struct ProjnameTest : TestWithParam<std::new_handler> {
    char const* args[1] = {__FILE__};
};

TEST_P(ProjnameTest, run) {
    std::set_new_handler(GetParam());
    EXPECT_EQ(369, projname::run({args, 1}));
    std::set_new_handler(nullptr);
}

std::new_handler const various_new_handlers[] = {
    nullptr,
    [] { std::terminate(); },
};

INSTANTIATE_TEST_CASE_P(VariousNewHandlers,
                        ProjnameTest,
                        ValuesIn(various_new_handlers));

}  // namespace
