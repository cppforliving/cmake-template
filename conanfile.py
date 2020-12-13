from conans import ConanFile


class ProjnameConan(ConanFile):
    name = "projname"
    version = "0.1.0"
    description = "C++ x GTest/Catch2/Doctest x GCC/Clang/MSVC x CMake x Conan/Vcpkg x Linux/macOS/Windows"
    requires = (
        "asio/[>=1.18.0]",
        "benchmark/[>=1.5.2]",
        "catch2/[>=2.13.3]",
        "doctest/[>=2.4.1]",
        "fmt/[>=7.1.2]",
        "gtest/[>=1.10.0]",
        "pybind11/[>=2.6.1]",
        "span-lite/[>=0.9.0]",
        "spdlog/[>=1.8.2]",
        "tbb/[>=2020.3]",
        "tl-expected/[>=1.0.0]",
        "tl-optional/[>=1.0.0]",
    )
    generators = ("cmake_find_package", "cmake_paths", "virtualrunenv")
    default_options = {"*:shared": True}
