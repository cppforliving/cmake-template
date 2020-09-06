#include <absl/base/casts.h>
#include <absl/types/span.h>
#include <cstdint>
#include <fmt/format.h>
#include <projname/projname.hpp>
#include <spdlog/spdlog.h>
#include <vector>

extern "C" int LLVMFuzzerTestOneInput(std::uint8_t const* data, std::size_t size);

int LLVMFuzzerTestOneInput(std::uint8_t const* data, std::size_t const size) {
    absl::Span<std::uint8_t const> const data_span{data, size};
    std::vector<char> cdata;
    cdata.reserve(size + 1);
    for (auto& byte : data_span) {
        cdata.push_back(absl::bit_cast<char>(byte));
    }
    cdata.push_back('\0');
    spdlog::info("{} size: {} data: '{}'", __func__, size, cdata.data());

    std::vector<char const*> args;
    args.push_back(cdata.data());
    for (std::size_t i = 1; i < cdata.size(); ++i) {
        if (cdata[i] == '\0') {
            args.push_back(&cdata[i - 1]);
        }
    }
    projname::run(static_cast<int>(args.size()), args.data());
    return 0;
}
