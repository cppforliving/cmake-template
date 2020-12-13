#include "projname.hpp"

#include <asio/io_context.hpp>
#include <asio/post.hpp>
#include <asio/steady_timer.hpp>
#include <chrono>
#include <cstdlib>
#include <fmt/format.h>
#include <span>
#include <string_view>
#include <system_error>
#include <thread>

using std::string_view_literals::operator""sv;
using std::chrono_literals::operator""ms;

namespace projname {

void ContinuousGreeter::operator()() const {
    asio::steady_timer timer{io};
    timer.expires_after(1ms);
    timer.async_wait(and_then([copy = *this] { copy(); }));
}

void StopIoContext::operator()() const {
    io.stop();
}

int run(std::vector<std::string> const& args) {
    spdlog::info("{} args: <{}>", __func__, fmt::format("{}", fmt::join(args, "> <"sv)));

    asio::io_context io;

    asio::steady_timer timer{io};
    timer.expires_after(1ms);
    timer.async_wait(and_then(StopIoContext{io}));

    asio::post(io, ContinuousGreeter{io});

    std::thread{[&io] {
        while (!io.stopped()) {
            io.run();
        }
        spdlog::info("Stopped!"sv);
    }}
        .join();

    return EXIT_SUCCESS;
}

int run(int const argc, char const* const argv[]) {
    std::span const args_span{argv, static_cast<std::size_t>(argc)};
    std::vector<std::string> args{args_span.begin(), args_span.end()};
    return run(args);
}

}  // namespace projname
