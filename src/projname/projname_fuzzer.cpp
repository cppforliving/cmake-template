#include <cstdint>
#include <cstdlib>
#include <fmt/format.h>
#include <nonstd/span.hpp>
#include <projname/projname.hpp>
#include <spdlog/spdlog.h>
#include <vector>

extern "C" int LLVMFuzzerTestOneInput(std::uint8_t const* data, std::size_t size);

int LLVMFuzzerTestOneInput(std::uint8_t const* const data, std::size_t const size) {
    nonstd::span const data_span{data, nonstd::span_lite::to_size(size)};

    auto const zdata = [data_span] {
        std::vector<char> zdata;
        zdata.reserve(data_span.size() + 1);
        zdata.assign(data_span.begin(), data_span.end());
        zdata.push_back('\0');
        return zdata;
    }();
    nonstd::span const zdata_span{zdata};

    auto const args = [zdata_span] {
        std::vector<char const*> args;
        args.push_back(zdata_span.data());
        for (std::size_t i = 1; i < zdata_span.size(); ++i) {
            if (zdata_span[i] == '\0') {
                args.push_back(&zdata_span[i - 1]);
            }
        }
        return args;
    }();

    projname::run(static_cast<int>(args.size()), args.data());

    return EXIT_SUCCESS;
}
