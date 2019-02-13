#ifndef EXAMPLE_EXAMPLE_HPP_
#define EXAMPLE_EXAMPLE_HPP_

#include "example/Config.h"

/**
 * @startuml
 * component example
 * @enduml
 */
namespace example {
namespace detail {
EXAMPLE_API int get123();

EXAMPLE_API int* newInt();

}  // namespace detail

/**
 * Allocates int 123 on heap and returns its pointer
 */
EXAMPLE_API int* newInt123();

class Base {
public:
    virtual ~Base() = default;
    virtual void virtualMethod() = 0;

protected:
    int protectedMethod() { return ++protectedMember; }
    int protectedMember{0};

private:
    int privateMethod() { return ++privateMember; }
    int privateMember{0};
};

class Derived : public Base {
public:
    void virtualMethod() override {}
};

}  // namespace example

#endif  // EXAMPLE_EXAMPLE_HPP_
