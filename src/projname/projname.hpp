#ifndef PROJNAME_PROJNAME_HPP
#define PROJNAME_PROJNAME_HPP

#ifdef _WIN32
#include <SDKDDKVer.h>
#endif

#include <boost/asio/io_context.hpp>
#include <boost/system/error_code.hpp>
#include <string>
#include <vector>

#include <projname/export.h>

namespace projname {

struct ContinuousGreeter {
    boost::asio::io_context& io;

    void operator()() const;
};

struct StopIoContext {
    boost::asio::io_context& io;

    PROJNAME_EXPORT void operator()(boost::system::error_code const& ec);
};

PROJNAME_EXPORT int run(std::vector<std::string> const& args);

PROJNAME_EXPORT int run(int const argc, char const* const argv[]);

}  // namespace projname

#endif  // PROJNAME_PROJNAME_HPP
