#include <pybind11/pybind11.h>
#include <pybind11/stl.h>  // IWYU pragma: keep

#include <string>
#include <vector>

#include "projname.hpp"

PYBIND11_MODULE(pyprojname, m) {
    m.def("run", [](std::vector<std::string> const& args) { return projname::run(args); });
}
