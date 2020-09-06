#include <gtest/gtest.h>
#include <string>
#include <tl/expected.hpp>

using std::string_literals::operator""s;

namespace examples {
namespace {

[[nodiscard]] tl::expected<int, std::string> process(bool const result) noexcept {
    if (result) {
        return 12345;
    } else {
        return tl::make_unexpected("failure"s);
    }
}

TEST(Expected, expected) {
    EXPECT_EQ(12345, process(true).value());
    EXPECT_EQ("failure"s, process(false).error());
}

} // namespace
} // namespace examples
