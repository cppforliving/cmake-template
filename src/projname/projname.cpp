#include "projname.hpp"

#include <boost/asio/deadline_timer.hpp>
#include <boost/asio/io_context.hpp>
#include <boost/asio/post.hpp>
#include <boost/beast/core/span.hpp>
#include <boost/date_time/posix_time/posix_time_duration.hpp>
#include <iostream>
#include <thread>

namespace projname {

void ContinuousGreeter::operator()() const {
    std::cout << '!';
    boost::asio::post(io, ContinuousGreeter{*this});
}

void StopIoContext::operator()(boost::system::error_code const& ec) {
    if (!ec) {
        io.stop();
    } else {
        std::cerr << ec.message() << std::endl;
    }
}

int run(boost::beast::span<char const* const> const args) {
    std::cout << __func__ << " args:";
    for (auto const arg : args) {
        std::cout << ' ' << arg;
    }
    std::cout << std::endl;

    boost::asio::io_context io;
    boost::asio::deadline_timer timer{io, boost::posix_time::milliseconds{1}};

    timer.async_wait(StopIoContext{io});

    boost::asio::post(io, ContinuousGreeter{io});

    std::thread thread{[&io] {
        while (!io.stopped()) {
            io.run();
        }
        std::cout << "Stopped!" << std::endl;
    }};

    thread.join();

    return 0;
}

}  // namespace projname
