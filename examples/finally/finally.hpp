#ifndef FINALLY_FINALLY_HPP
#define FINALLY_FINALLY_HPP

#include <type_traits>
#include <utility>

namespace finally {

template <typename F>
class finally {
    static_assert(std::is_same_v<F, std::decay_t<F>>);

  public:
    constexpr explicit finally(F f) noexcept(
        std::is_nothrow_move_constructible_v<F>)
        : m_f{std::move(f)} {}

    finally() = delete;
    ~finally() { m_f(); }

    finally(finally const&) = delete;
    void operator=(finally const&) = delete;

  private:
    F m_f;
};

}  // namespace finally

#endif  // FINALLY_FINALLY_HPP
