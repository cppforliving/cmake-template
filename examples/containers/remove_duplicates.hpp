#ifndef EXAMPLES_CONTAINERS_REMOVE_DUPLICATES_HPP_
#define EXAMPLES_CONTAINERS_REMOVE_DUPLICATES_HPP_

#include <algorithm>

namespace examples {

template<typename C>
void remove_duplicates(C& c) {
    std::sort(c.begin(), c.end());
    c.erase(std::unique(c.begin(), c.end()), c.end());
}

}  // namespace examples

#endif  // EXAMPLES_CONTAINERS_REMOVE_DUPLICATES_HPP_
