#include "lockable.hpp"

#include <benchmark/benchmark.h>
#include <string>

namespace projname {
namespace {

void LockableLockUnlock(benchmark::State& state) {
    Lockable<std::string> s1;
    for (auto _ : state) {
        s1.lock();
        s1.unlock();
    }
}
BENCHMARK(LockableLockUnlock);

}  // namespace
}  // namespace projname
