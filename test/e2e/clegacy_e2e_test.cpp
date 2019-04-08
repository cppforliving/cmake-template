#include <clegacy/clegacy.h>
#include <stdlib.h>
#include <catch2/catch.hpp>

TEST_CASE("clegacy_e2e_test.all") {
    auto x = clegacy_newInt123();
    REQUIRE(*x == 123);
    free(x);
}
