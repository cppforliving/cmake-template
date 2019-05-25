#ifndef EXAMPLE_SSIZE_HPP
#define EXAMPLE_SSIZE_HPP

#include <cstddef>
#include <type_traits>

namespace avgd {

template <typename C>
constexpr auto ssize(C const& c)
    -> std::common_type_t<std::ptrdiff_t,
                          std::make_signed_t<decltype(c.size())>> {
    return static_cast<std::common_type_t<
        std::ptrdiff_t, std::make_signed_t<decltype(c.size())>>>(c.size());
}

template <typename T, std::ptrdiff_t N>
constexpr std::ptrdiff_t ssize(T const (&)[N]) noexcept {
    return N;
}

}  // namespace avgd

#endif  // EXAMPLE_SSIZE_HPP
