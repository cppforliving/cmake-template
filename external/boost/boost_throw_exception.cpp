#include <exception>

#include <boost/throw_exception.hpp>

namespace boost {

void throw_exception(std::exception const& /*unused*/) noexcept {
    std::terminate();
}

}  // namespace boost
