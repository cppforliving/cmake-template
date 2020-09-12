#include "projname.hpp"

#include <asio/io_context.hpp>
#include <asio/steady_timer.hpp>
#include <chrono>
#include <fmt/format.h>
#include <nonstd/span.hpp>
#include <string_view>
#include <system_error>
#include <thread>

using std::string_view_literals::operator""sv;
using std::chrono_literals::operator""ms;

namespace projname {

void ContinuousGreeter::operator()(asio::yield_context const yield) const {
    asio::steady_timer timer{io};
    timer.expires_after(1ms);
    timer.async_wait(and_then([copy = *this, yield] { copy(yield); }));
}

void StopIoContext::operator()() const {
    io.stop();
}

int run(std::vector<std::string> const& args) {
    spdlog::info("{} args: <{}>", __func__, fmt::join(args, "> <"sv));

    asio::io_context io;

    asio::steady_timer timer{io};
    timer.expires_after(1ms);
    timer.async_wait(and_then(StopIoContext{io}));

    asio::spawn(io, ContinuousGreeter{io});

    std::thread{[&io] {
        while (!io.stopped()) {
            io.run();
        }
        spdlog::info("Stopped!"sv);
    }}.join();

    return 0;
}

int run(int const argc, char const* const argv[]) {
    nonstd::span const args_span{argv, nonstd::span_lite::to_size(argc)};
    std::vector<std::string> args{args_span.begin(), args_span.end()};
    return run(args);
}

} // namespace projname
