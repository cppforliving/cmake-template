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

enum class Direction { North, East, South, West };

TEST(Variant, visitor) {
    std::variant<
        std::ptrdiff_t,
        Direction,
        std::string,
        std::vector<std::byte>,
        std::function<std::size_t()>>
        v{std::ptrdiff_t{-1}};

    auto const v_size = std::visit(
        overloaded{
            [](std::size_t const n) { return n; },
            [](Direction const d) -> std::size_t {
                switch (d) {
                    case Direction::North: {
                        auto const x = 1;
                        return x;
                    }
                    case Direction::East: return 2;
                    case Direction::South: return 3;
                    case Direction::West: return 4;
                }
                return 0;
            },
            [](std::function<std::size_t()> const& f) { return f(); },
            [](std::string_view const s) { return s.length(); },
            [](std::vector<std::byte> const& v) { return v.size(); },
        },
        v);

    ASSERT_EQ(std::ptrdiff_t{-1}, static_cast<std::ptrdiff_t>(v_size));
}

} // namespace
} // namespace examples
