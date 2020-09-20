#include "projname.hpp"

#include <asio/error.hpp>
#include <asio/io_context.hpp>
#include <gtest/gtest.h>

namespace projname {
namespace {

TEST(projname, stop_io_context_success) {
    asio::io_context io;
    StopIoContext{io}({});
    EXPECT_TRUE(io.stopped());
}

TEST(projname, stop_io_context_failure) {
    asio::io_context io;
    StopIoContext{io}(asio::error::operation_aborted);
    EXPECT_FALSE(io.stopped());
}

}  // namespace
}  // namespace projname
