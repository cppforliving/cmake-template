#include "derived.hpp"

namespace example {

Base::~Base() = default;

int Base::protectedMember{13};

int Base::protectedMethod() {
    return ++protectedMember + privateMethod();
}

const int Base::privateMember;

int Base::privateMethod() {
    return privateMember;
}

void Derived::virtualMethod() {}

}  // namespace example
