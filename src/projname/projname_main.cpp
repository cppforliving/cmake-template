#include "projname.hpp"

#include <cstddef>
#include <exception>
#include <new>

int main(int const argc, char const* const argv[]) THROWS {
    std::set_new_handler([]() noexcept { std::terminate(); });

    return projname::run({argv, static_cast<std::size_t>(argc)});
}
