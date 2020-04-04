#ifndef FINALLY_FINALLY_HPP
#define FINALLY_FINALLY_HPP

#include <type_traits>
#include <utility>

namespace finally {
namespace detail {

template <typename F>
class FinalAction {
    static_assert(std::is_same_v<F, std::decay_t<F>>);

  public:
    constexpr explicit FinalAction(F f) noexcept(
        std::is_nothrow_move_constructible_v<F>)
        : m_f{std::move(f)} {}

    FinalAction() = delete;
    ~FinalAction() { m_f(); }

    FinalAction(FinalAction const&) = delete;
    void operator=(FinalAction const&) = delete;

  private:
    F m_f;
};

}  // namespace detail

template <typename F>
constexpr auto finally(F&& f) noexcept(
    noexcept(detail::FinalAction<std::decay_t<F>>{std::forward<F>(f)})) {
    return detail::FinalAction<std::decay_t<F>>{std::forward<F>(f)};
}

}  // namespace finally

#endif  // FINALLY_FINALLY_HPP
