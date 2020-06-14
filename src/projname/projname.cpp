#include "projname.hpp"

#include <asio/io_context.hpp>
#include <asio/post.hpp>
#include <asio/steady_timer.hpp>
#include <chrono>
#include <iostream>
#include <string_view>
#include <system_error>
#include <thread>

using std::string_view_literals::operator""sv;
using std::chrono_literals::operator""ms;

namespace projname {

void ContinuousGreeter::operator()() const {
    std::cout << '!';
    asio::post(io, ContinuousGreeter{*this});
}

void StopIoContext::operator()(std::error_code const& ec) {
    if (!ec) {
        io.stop();
    } else {
        std::cerr << ec.message() << std::endl;
    }
}

int run(std::vector<std::string> const& args) {
    std::cout << __func__ << " args:"sv;
    for (auto const& arg : args) {
        std::cout << ' ' << arg;
    }
    std::cout << std::endl;

    asio::io_context io;

    asio::steady_timer timer{io};
    timer.expires_after(1ms);
    timer.async_wait(StopIoContext{io});

    asio::post(io, ContinuousGreeter{io});

    std::thread thread{[&io] {
        while (!io.stopped()) {
            io.run();
        }
        std::cout << "Stopped!"sv << std::endl;
    }};

    thread.join();

    return 0;
}

int run(int const argc, char const* const argv[]) {
    std::vector<std::string> args;
    args.reserve(static_cast<decltype(args)::size_type>(argc));
    for (int i = 0; i < argc; ++i) {
        args.emplace_back(argv[i]);
    }
    return run(args);
}

}  // namespace projname
