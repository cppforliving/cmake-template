#ifdef _WIN32
#include <SDKDDKVer.h>
#endif
#include <boost/asio/deadline_timer.hpp>
#include <boost/asio/io_service.hpp>
#include <boost/date_time/posix_time/posix_time.hpp>
#include <boost/system/error_code.hpp>
#include <exception>
#include <iostream>
#include <new>
#include <thread>
#include "clegacy/clegacy.h"
#include "example/example.hpp"

using boost::asio::deadline_timer;
using boost::asio::io_service;
using boost::posix_time::milliseconds;
using boost::system::error_code;

struct ContinuousGreeter {
    io_service& io;

    void operator()() const {
        std::cout << "Hello, Asio!" << std::endl;
        io.post(ContinuousGreeter{*this});
    }
};

int main() {
    std::set_new_handler([] { std::terminate(); });

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

    return *clegacy_newInt123() + *example::newInt123();
}
