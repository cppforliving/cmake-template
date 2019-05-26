#include "projname.hpp"

#include <iostream>
#include <thread>

#include <boost/asio/deadline_timer.hpp>
#include <boost/asio/io_service.hpp>
#include <boost/date_time/posix_time/posix_time_duration.hpp>
#include <boost/system/error_code.hpp>
#include <gsl/gsl_assert>
#include <gsl/span>

#include <capicpp/capicpp.h>
#include <clegacy/clegacy.h>
#include <example/example.hpp>

namespace projname {

using boost::asio::deadline_timer;
using boost::asio::io_service;
using boost::posix_time::milliseconds;
using boost::system::error_code;

void ContinuousGreeter::operator()() const {
    std::cout << "Hi! ";
    io.post(ContinuousGreeter{*this});
}

int run(gsl::span<char const*> args) {
    std::cout << "args:";
    for (auto& arg : args) {
        std::cout << ' ' << arg;
    }
    std::cout << std::endl;

    io_service io;
    deadline_timer timer{io, milliseconds{1}};

    timer.async_wait([&io](error_code const& ec) {
        if (!ec) {
            io.stop();
        }
    });

    io.post(ContinuousGreeter{io});

    std::thread thread{[&io] {
        error_code ec;
        while (!ec && !io.stopped()) {
            io.run(ec);
        }
        if (ec) {
            std::cout << "Aborted! " << ec << std::endl;
        } else {
            std::cout << "Stopped!" << std::endl;
        }
    }};

    thread.join();

    Ensures(!thread.joinable());

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
