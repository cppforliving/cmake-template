#include <gtest/gtest.h>
#include <string>
#include <utility>
#include <variant>
#include <vector>

namespace examples {
namespace {

template<typename... Ts>
struct overloaded : Ts... {
    using Ts::operator()...;
};

template<typename... Ts>
overloaded(Ts...)->overloaded<Ts...>;

TEST(Variant, visitor) {
    std::variant<
        std::ptrdiff_t,
        std::size_t,
        std::string,
        std::vector<std::byte>,
        std::function<std::size_t()>>
        v{-1};

    auto const v_size = std::visit(
        overloaded{
            [](std::size_t const len) { return len; },
            [](std::function<std::size_t()> const& fun) { return fun(); },
            [](std::string const& str) { return str.length(); },
            [](std::vector<std::byte> const& bytes) { return bytes.size(); },
        },
        v);

    ASSERT_EQ(std::ptrdiff_t{-1}, v_size);
}

} // namespace
} // namespace examples
