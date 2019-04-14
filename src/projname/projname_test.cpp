#include "projname.hpp"

#include <exception>
#include <new>

#include <gtest/gtest.h>
#include <gsl/gsl_util>

namespace {

using namespace projname;

using testing::TestWithParam;
using testing::Values;

struct ProjnameTest : TestWithParam<std::new_handler> {
    char const* args[1]{__FILE__};
};

TEST_P(ProjnameTest, run) {
    std::set_new_handler(GetParam());
    auto const finalize = gsl::finally([] { std::set_new_handler(nullptr); });
    EXPECT_EQ(246, run(args));
}

INSTANTIATE_TEST_CASE_P(VariousNewHandlers,
                        ProjnameTest,
                        Values(nullptr,
                               [] { throw std::bad_alloc{}; },
                               [] { std::terminate(); }));

}  // namespace
