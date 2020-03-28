#include "projname.hpp"

#include <exception>
#include <new>

int main(int const argc, char const* const argv[]) {
    std::set_new_handler([] { std::terminate(); });

    return projname::run(argc, argv);
}
