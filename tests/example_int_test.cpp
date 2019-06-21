#include <catch2/catch.hpp>

#include <example/example.hpp>

namespace {

TEST_CASE("Example.all") {
    auto x = example::newInt123();
    REQUIRE(*x == 123);
    delete x;
}

}  // namespace
