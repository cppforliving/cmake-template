from conans import ConanFile


class ProjnameConan(ConanFile):
    name = "projname"
    version = "0.1.0"
    description = "C++ x GTest/Catch2/Doctest x GCC/Clang/MSVC x CMake x Conan/Vcpkg x Linux/macOS/Windows"
    requires = (
        "asio/[>=1.17.0]",
        "benchmark/[>=1.5.1]",
        "catch2/[>=2.13.1]",
        "doctest/[>=2.4.0]",
        "fmt/[>=7.0.3]",
        "gtest/[>=1.10.0]",
        "pybind11/[>=2.5.0]",
        "span-lite/[>=0.7.0]",
        "spdlog/[>=1.8.0]",
        "tbb/[>=2020.2]",
        "tl-expected/[>=1.0.0]",
        "tl-optional/[>=1.0.0]",
    )
    generators = ("cmake_find_package", "cmake_paths", "virtualrunenv")
    default_options = {"*:shared": True}
