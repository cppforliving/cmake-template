#include <catch2/catch.hpp>
#include "clegacy/clegacy.h"

TEST_CASE("clegacy_e2e_test.all") {
    auto x = clegacy_newInt123();
    REQUIRE(*x == 123);
    delete x;
}
