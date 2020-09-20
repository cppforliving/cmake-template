#ifndef EXAMPLES_FINALLY_FINALLY_HPP_
#define EXAMPLES_FINALLY_FINALLY_HPP_

#include <type_traits>
#include <utility>

namespace examples {

template<typename F>
class [[nodiscard]] finally {
    static_assert(std::is_same_v<F, std::decay_t<F>>);

  public:
    constexpr explicit finally(F f) noexcept(std::is_nothrow_move_constructible_v<F>)
        : m_f{std::move(f)} {}

    finally() = delete;
    ~finally() {
        m_f();
    }

    finally(finally const&) = delete;
    void operator=(finally const&) = delete;

  private:
    F m_f;
};

template<typename F>
finally(F)->finally<F>;

}  // namespace examples

#endif  // EXAMPLES_FINALLY_FINALLY_HPP_
