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
        v{-1};

    auto const v_size = std::visit(
        overloaded{
            [](std::size_t const len) { return len; },
            [](Direction const dir) -> std::size_t {
                switch (dir) {
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
            [](std::function<std::size_t()> const& fun) { return fun(); },
            [](std::string const& str) { return str.length(); },
            [](std::vector<std::byte> const& bytes) { return bytes.size(); },
        },
        v);

    ASSERT_EQ(std::ptrdiff_t{-1}, v_size);
}

} // namespace
} // namespace examples
