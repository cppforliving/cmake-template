#include <doctest/doctest.h>
#include <exception>
#include <memory>
#include <new>

#include <projname/projname.hpp>

namespace {

TEST_CASE("IntegrationTest.run") {
    char const* const args[] = {__FILE__};
    SUBCASE("DefaultNewHandlers") {
        std::set_new_handler(nullptr);
        REQUIRE(0 == projname::run(1, args));
        std::set_new_handler(nullptr);
    }
    SUBCASE("TerminateNewHandlers") {
        std::set_new_handler([] { std::terminate(); });
        REQUIRE(0 == projname::run(1, args));
        std::set_new_handler(nullptr);
    }
}

}  // namespace
