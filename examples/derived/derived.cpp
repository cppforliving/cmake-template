#include "derived.hpp"

namespace derived {

Base::~Base() = default;

std::atomic_int32_t Base::PROTECTED_MEMBER{13};

std::int32_t Base::protected_method() {
    return PROTECTED_MEMBER.fetch_add(1, std::memory_order_acq_rel) + private_method();
}

std::int32_t const Base::PRIVATE_MEMBER;

std::int32_t Base::private_method() {
    return PRIVATE_MEMBER;
}

void Derived::virtual_method() {}

} // namespace derived
