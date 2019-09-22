#ifndef PROJNAME_PROJNAME_HPP
#define PROJNAME_PROJNAME_HPP

#ifdef _WIN32
#include <SDKDDKVer.h>
#endif

#include <boost/asio/io_context.hpp>
#include <boost/beast/core/span.hpp>

#include <projname/config.h>

namespace projname {

struct ContinuousGreeter {
    boost::asio::io_context& io;

    void operator()() const;
};

PROJNAME_EXPORT int run(boost::beast::span<char const* const> args);

}  // namespace projname

#endif  // PROJNAME_PROJNAME_HPP
