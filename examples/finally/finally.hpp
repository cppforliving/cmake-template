#ifndef FINALLY_FINALLY_HPP
#define FINALLY_FINALLY_HPP

#include <type_traits>
#include <utility>

namespace finally {
namespace detail {

template <typename F>
class FinalAction {
  public:
    explicit FinalAction(F f) noexcept(std::is_nothrow_move_constructible_v<F>)
        : m_f{std::move(f)} {}
    ~FinalAction() { m_f(); }

    FinalAction(FinalAction const&) = delete;
    void operator=(FinalAction const&) = delete;

  private:
    static_assert(std::is_same_v<std::decay_t<F>, F>);

    F m_f;
};

}  // namespace detail

template <typename F>
detail::FinalAction<F> finally(F f) noexcept(noexcept(detail::FinalAction<F>{
    std::move(f)})) {
    return detail::FinalAction<F>{std::move(f)};
}

}  // namespace finally

#endif  // FINALLY_FINALLY_HPP
