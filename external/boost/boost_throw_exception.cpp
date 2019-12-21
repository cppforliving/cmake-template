#include <boost/throw_exception.hpp>
#include <exception>

namespace boost {

void throw_exception(std::exception const& /*unused*/) {
    std::terminate();
}

}  // namespace boost
