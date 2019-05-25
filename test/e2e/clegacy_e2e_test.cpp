#include <cstdlib>

#include <catch2/catch.hpp>

#include <clegacy/clegacy.h>

namespace {

TEST_CASE("Clegacy.all") {
    auto x = clegacy_newInt123();
    REQUIRE(*x == 123);
    clegacy_deleteInt123(x);
}

}  // namespace
