#include <catch2/catch.hpp>
#include <example/example.hpp>

namespace {

TEST_CASE("example_e2e_test.all") {
    auto x = example::newInt123();
    REQUIRE(*x == 123);
    delete x;
}

}  // namespace
