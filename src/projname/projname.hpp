#ifndef PROJNAME_PROJNAME_HPP_
#define PROJNAME_PROJNAME_HPP_

#ifdef _WIN32
#include <SDKDDKVer.h>
#endif

#include <asio/io_context.hpp>
#include <string>
#include <system_error>
#include <vector>

#include <projname/export.h>

namespace projname {

struct ContinuousGreeter {
    asio::io_context& io;

    void operator()() const;
};

struct StopIoContext {
    asio::io_context& io;

    PROJNAME_EXPORT void operator()(std::error_code const& ec);
};

PROJNAME_EXPORT int run(std::vector<std::string> const& args);

PROJNAME_EXPORT int run(int argc, char const* const argv[]);

}  // namespace projname

#endif  // PROJNAME_PROJNAME_HPP_
