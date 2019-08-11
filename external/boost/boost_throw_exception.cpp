#include <exception>
#include <iostream>

#include <boost/throw_exception.hpp>

#include "boost_throw_exception_export.h"

namespace boost {

BOOST_THROW_EXCEPTION_EXPORT void throw_exception(
    std::exception const& /*unused*/) {
    std::terminate();
}

}  // namespace boost
