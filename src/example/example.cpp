#include "example/example.hpp"

namespace example {
namespace detail {
int get123() {
    return 123;
}

int* newInt() {
    return new int;
}

}  // namespace detail

int* newInt123() {
    auto x = detail::newInt();
    *x = detail::get123();
    return x;
}

struct Local {};

static Local local;

Local& getLocalInstance() {
    return local;
}

}  // namespace example
