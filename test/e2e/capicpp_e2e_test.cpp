#include <catch2/catch.hpp>

#include <capicpp/capicpp.h>

namespace {

TEST_CASE("capicpp.all") {
    auto x = capicpp_newInt123();
    REQUIRE(*x == 123);
    capicpp_deleteInt123(x);
}

}  // namespace
