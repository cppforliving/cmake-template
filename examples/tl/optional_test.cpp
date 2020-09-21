#include <gtest/gtest.h>
#include <string>
#include <tl/optional.hpp>

using std::string_literals::operator""s;

namespace examples {
namespace {

[[nodiscard]] tl::optional<std::string> process(bool const result) noexcept {
    if (result) {
        return "success"s;
    }
    return tl::nullopt;
}

TEST(Optional, optional) {
    EXPECT_EQ("success"s, process(true).value());
    EXPECT_THROW(process(false).value(), tl::bad_optional_access);
}

}  // namespace
}  // namespace examples
