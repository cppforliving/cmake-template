#include "lockable.hpp"

#include <benchmark/benchmark.h>
#include <mutex>
#include <string>

namespace projname {
namespace {

void LockableLockUnlock(benchmark::State& state) {
    Lockable<std::string, std::mutex> s1;
    for ([[maybe_unused]] auto _ : state) {
        s1.lock();
        s1.unlock();
    }
}
BENCHMARK(LockableLockUnlock);

}  // namespace
}  // namespace projname
