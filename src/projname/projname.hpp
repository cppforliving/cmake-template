#ifndef PROJNAME_PROJNAME_HPP_
#define PROJNAME_PROJNAME_HPP_

#ifdef _WIN32
#include <SDKDDKVer.h>
#endif

#include <asio/io_context.hpp>
#include <spdlog/spdlog.h>
#include <string>
#include <system_error>
#include <vector>

#include <projname/export.h>

namespace projname {

template<typename F>
auto and_then(F f) {
    return [f](std::error_code const ec) mutable {
        if (!ec) {
            f();
        } else {
            spdlog::info("{}", ec.message());
        }
    };
}

template<typename F>
auto or_else(F f) {
    return [f](std::error_code const ec) mutable {
        if (ec) {
            f();
        } else {
            spdlog::info("{}", ec.message());
        }
    };
}

struct ContinuousGreeter {
    asio::io_context& io;

    void operator()() const;
};

struct StopIoContext {
    asio::io_context& io;

    PROJNAME_EXPORT void operator()() const;
};

PROJNAME_EXPORT int run(std::vector<std::string> const& args);

PROJNAME_EXPORT int run(int argc, char const* const argv[]);

}  // namespace projname

#endif  // PROJNAME_PROJNAME_HPP_
