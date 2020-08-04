#include "derived.hpp"

namespace derived {

Base::~Base() = default;

int Base::PROTECTED_MEMBER{13};

int Base::protected_method() {
    return ++PROTECTED_MEMBER + private_method();
}

int const Base::PRIVATE_MEMBER;

int Base::private_method() {
    return PRIVATE_MEMBER;
}

void Derived::virtual_method() {}

} // namespace derived
