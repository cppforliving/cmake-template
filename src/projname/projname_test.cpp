#include "projname.hpp"

#include <exception>
#include <new>

#include <gtest/gtest.h>
#include <boost/scope_exit.hpp>

namespace {

using namespace projname;

using testing::TestWithParam;
using testing::Values;

struct ProjnameTest : TestWithParam<std::new_handler> {
    char const* args[1]{__FILE__};
};

TEST_P(ProjnameTest, run) {
    std::set_new_handler(GetParam());
    BOOST_SCOPE_EXIT(void) { std::set_new_handler(nullptr); }
    BOOST_SCOPE_EXIT_END
    EXPECT_EQ(369, run({args, 1}));
}

INSTANTIATE_TEST_CASE_P(VariousNewHandlers,
                        ProjnameTest,
                        Values(nullptr,
                               [] { throw std::bad_alloc{}; },
                               [] { std::terminate(); }));

}  // namespace
