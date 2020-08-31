#include <doctest/doctest.h>
#include <exception>
#include <memory>
#include <new>

#include <projname/projname.hpp>

namespace {

TEST_CASE("IntegrationTest.run") {
    auto const args = {__FILE__};
    SUBCASE("DefaultNewHandlers") {
        std::set_new_handler(nullptr);
        REQUIRE(0 == projname::run(static_cast<int>(args.size()), std::data(args)));
        std::set_new_handler(nullptr);
    }
    SUBCASE("TerminateNewHandlers") {
        std::set_new_handler([] { std::terminate(); });
        REQUIRE(0 == projname::run(static_cast<int>(args.size()), std::data(args)));
        std::set_new_handler(nullptr);
    }
}

} // namespace
