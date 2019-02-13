#include <algorithm>
#include <catch2/catch.hpp>
#include <memory>
#include "example/example.hpp"

TEST_CASE("example_e2e_test.all") {
    auto x = example::newInt123();
    REQUIRE(*x == 123);
    delete x;
}

TEST_CASE("example_e2e_test.efence") {
    const auto a = std::make_unique<char[]>(sizeof("Alpha"));
    const auto b = std::make_unique<char[]>(sizeof("Bravo"));
    const auto c = "Charlie";
    std::copy(c, c + sizeof("Charlie"), a.get());
}
