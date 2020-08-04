#include "derived.hpp"

namespace derived {

Base::~Base() = default;

int Base::protected_member{13};

int Base::protected_method() {
    return ++protected_member + private_method();
}

int const Base::private_member;

int Base::private_method() {
    return private_member;
}

void Derived::virtual_method() {}

} // namespace derived
