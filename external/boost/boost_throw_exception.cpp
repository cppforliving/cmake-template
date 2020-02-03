#include <boost/throw_exception.hpp>
#include <exception>

namespace boost {

BOOST_NORETURN void throw_exception(std::exception const& /*unused*/) {
    std::terminate();
}

}  // namespace boost
