#include "projname.hpp"

#include <cassert>
#include <iostream>
#include <thread>

#include <boost/asio/deadline_timer.hpp>
#include <boost/asio/io_context.hpp>
#include <boost/asio/post.hpp>
#include <boost/beast/core/span.hpp>
#include <boost/date_time/posix_time/posix_time_duration.hpp>
#include <boost/system/error_code.hpp>

#include <capicpp/capicpp.h>
#include <clegacy/clegacy.h>
#include <example/example.hpp>

namespace projname {

using boost::asio::deadline_timer;
using boost::asio::io_context;
using boost::asio::post;
using boost::posix_time::milliseconds;
using boost::system::error_code;

void ContinuousGreeter::operator()() const {
    std::cout << "Hi! ";
    post(io, ContinuousGreeter{*this});
}

int run(boost::beast::span<char const*> args) {
    std::cout << "args:";
    for (auto& arg : args) {
        std::cout << ' ' << arg;
    }
    std::cout << std::endl;

    io_context io;
    deadline_timer timer{io, milliseconds{1}};

    timer.async_wait([&io](error_code const& ec) {
        if (!ec) {
            io.stop();
        }
    });

    post(io, ContinuousGreeter{io});

    std::thread thread{[&io] {
        while (!io.stopped()) {
            io.run();
        }
        std::cout << "Stopped!" << std::endl;
    }};

    thread.join();

    assert(!thread.joinable());

    auto const p = capicpp_newInt123();
    auto const c = clegacy_newInt123();
    auto const e = example::newInt123();
    auto const x = *p + *c + *e;
    capicpp_deleteInt123(p);
    clegacy_deleteInt123(c);
    delete e;
    return x;
}

}  // namespace projname
