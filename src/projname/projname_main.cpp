#include "projname.hpp"

#include <exception>
#include <new>

int main(int argc, char const* argv[]) {
    std::set_new_handler([] { std::terminate(); });

    return projname::run({argv, static_cast<std::size_t>(argc)});
}
