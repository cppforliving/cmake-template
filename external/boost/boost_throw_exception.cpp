#include <exception>
#include <iostream>

#include <boost/throw_exception.hpp>

namespace boost {

void throw_exception(std::exception const& /*unused*/) {
    std::terminate();
}

}  // namespace boost
