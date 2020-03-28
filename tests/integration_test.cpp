#include <catch2/catch.hpp>
#include <exception>
#include <memory>
#include <new>

#include <projname/projname.hpp>

namespace {

TEST_CASE("IntegrationTest.run") {
    char const* const args[] = {__FILE__};
    auto const various_new_handler =
        GENERATE(as<std::new_handler>{}, nullptr, [] { std::terminate(); });
    SECTION("VariousNewHandlers") {
        std::set_new_handler(various_new_handler);
        REQUIRE(0 == projname::run(1, args));
        std::set_new_handler(nullptr);
    }
}

}  // namespace
