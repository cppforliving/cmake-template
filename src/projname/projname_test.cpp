#include "projname.hpp"

#include <boost/asio/error.hpp>
#include <boost/asio/io_context.hpp>

#include <gtest/gtest.h>

namespace {

TEST(projname, stop_io_context_success) {
    boost::asio::io_context io;
    projname::StopIoContext{io}({});
    EXPECT_TRUE(io.stopped());
}

TEST(projname, stop_io_context_failure) {
    boost::asio::io_context io;
    projname::StopIoContext{io}(boost::asio::error::operation_aborted);
    EXPECT_FALSE(io.stopped());
}

}  // namespace
