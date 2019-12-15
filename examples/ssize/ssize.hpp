#ifndef SSIZE_SSIZE_HPP
#define SSIZE_SSIZE_HPP

#include <cstddef>
#include <type_traits>

namespace ssize {

template <typename C>
constexpr auto ssize(C const& c)
    -> std::common_type_t<std::ptrdiff_t,
                          std::make_signed_t<decltype(c.size())>> {
    return static_cast<std::common_type_t<
        std::ptrdiff_t, std::make_signed_t<decltype(c.size())>>>(c.size());
}

template <typename T, std::size_t N>
constexpr std::ptrdiff_t ssize(T const (&)[N]) noexcept {
    return N;
}

}  // namespace ssize

#endif  // SSIZE_SSIZE_HPP
