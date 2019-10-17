#include "projname.hpp"

#include <algorithm>
#include <cstdint>
#include <iterator>
#include <string>

extern "C" int LLVMFuzzerTestOneInput(std::uint8_t const* const data,
                                      std::size_t const size) {
    std::basic_string<std::uint8_t> zdata;
    zdata.reserve(size + 1);
    std::copy_n(data, size, std::back_inserter(zdata));
    zdata.push_back('\0');
    std::size_t const argc = !zdata.empty();
    char const* const argv[] = {reinterpret_cast<char const*>(zdata.c_str())};
    projname::run({argv, argc});
    return 0;
}
