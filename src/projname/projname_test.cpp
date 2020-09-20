#include "projname.hpp"

#include <asio/error.hpp>
#include <asio/io_context.hpp>
#include <gtest/gtest.h>

namespace projname {
namespace {

TEST(projname, and_then_stop_io_context_success) {
    asio::io_context io;
    and_then(StopIoContext{io})({});
    EXPECT_TRUE(io.stopped());
}

TEST(projname, and_then_stop_io_context_failure) {
    asio::io_context io;
    and_then(StopIoContext{io})(asio::error::operation_aborted);
    EXPECT_FALSE(io.stopped());
}

TEST(projname, or_else_stop_io_context_failure) {
    asio::io_context io;
    or_else(StopIoContext{io})({});
    EXPECT_FALSE(io.stopped());
}

TEST(projname, or_else_stop_io_context_success) {
    asio::io_context io;
    or_else(StopIoContext{io})(asio::error::operation_aborted);
    EXPECT_TRUE(io.stopped());
}

}  // namespace
}  // namespace projname
