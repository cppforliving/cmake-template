#ifndef EXAMPLES_FINALLY_FINALLY_HPP_
#define EXAMPLES_FINALLY_FINALLY_HPP_

#include <type_traits>
#include <utility>

namespace examples {

template<typename F>
class [[nodiscard]] Finally {
    static_assert(std::is_same_v<F, std::decay_t<F>>);

  public:
    constexpr explicit Finally(F f) noexcept(std::is_nothrow_move_constructible_v<F>)
        : m_f{std::move(f)} {}

    Finally() = delete;
    ~Finally() {
        m_f();
    }

    Finally(Finally const&) = delete;
    void operator=(Finally const&) = delete;

  private:
    F m_f;
};

template<typename F>
Finally(F)->Finally<F>;

}  // namespace examples

#endif  // EXAMPLES_FINALLY_FINALLY_HPP_
