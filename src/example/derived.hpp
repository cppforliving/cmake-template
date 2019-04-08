#ifndef EXAMPLE_DERIVED_HPP_
#define EXAMPLE_DERIVED_HPP_

#include <example/export.h>

/**
 * @startuml
 * component example
 * @enduml
 */
namespace example {

class Base {
public:
    EXAMPLE_EXPORT virtual ~Base() = default;
    EXAMPLE_EXPORT virtual void virtualMethod() = 0;

protected:
    EXAMPLE_EXPORT int protectedMethod() { return ++protectedMember; }
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

#endif  // EXAMPLE_DERIVED_HPP_
