#include <algorithm>
#include <chrono>
#include <gtest/gtest.h>
#include <tbb/parallel_for_each.h>
#include <tbb/task_scheduler_init.h>
#include <thread>
#include <vector>

#include <containers/remove_duplicates.hpp>
#include <containers/ssize.hpp>

using std::chrono_literals::operator""ms;

namespace examples {
namespace {

TEST(Parallel, for_each) {
    tbb::task_scheduler_init anonymous;
    std::vector<std::thread::id> tids(32);

    tbb::parallel_for_each(tids, [](auto& tid) {
        std::this_thread::sleep_for(10ms);
        tid = std::this_thread::get_id();
    });
    remove_duplicates(tids);

    EXPECT_LT(1, examples::ssize(tids));
}

}  // namespace
}  // namespace examples
