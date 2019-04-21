#ifndef PROJNAME_PROJNAME_HPP
#define PROJNAME_PROJNAME_HPP

#ifdef _WIN32
#include <SDKDDKVer.h>
#endif

#include <boost/asio/io_service.hpp>
#include <gsl/span>

namespace projname {

struct ContinuousGreeter {
    boost::asio::io_service& io;

    void operator()() const;
};

int run(gsl::span<char const*> args);

}  // namespace projname

#endif  // PROJNAME_PROJNAME_HPP
