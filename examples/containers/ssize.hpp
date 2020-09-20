#ifndef EXAMPLES_CONTAINERS_SSIZE_HPP_
#define EXAMPLES_CONTAINERS_SSIZE_HPP_

#include <cstddef>
#include <type_traits>

namespace examples {

template<typename C>
constexpr auto ssize(C const& c)
    -> std::common_type_t<std::ptrdiff_t, std::make_signed_t<decltype(c.size())>> {
    return static_cast<std::common_type_t<std::ptrdiff_t, std::make_signed_t<decltype(c.size())>>>(
        c.size());
}

template<typename T, std::size_t N>
constexpr std::ptrdiff_t ssize(T const (&/*unused*/)[N]) noexcept {
    return N;
}

}  // namespace examples

#endif  // EXAMPLES_CONTAINERS_SSIZE_HPP_
