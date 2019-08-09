#ifndef PROJNAME_PROJNAME_HPP
#define PROJNAME_PROJNAME_HPP

#ifdef _WIN32
#include <SDKDDKVer.h>
#endif

#include <boost/asio/io_context.hpp>
#include <boost/beast/core/span.hpp>

namespace projname {

struct ContinuousGreeter {
    boost::asio::io_context& io;

    void operator()() const;
};

int run(boost::beast::span<char const*> args);

}  // namespace projname

#endif  // PROJNAME_PROJNAME_HPP
