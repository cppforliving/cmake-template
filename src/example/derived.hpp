#ifndef EXAMPLE_DERIVED_HPP_
#define EXAMPLE_DERIVED_HPP_

#include <example/export.h>

/**
 * @startuml
 * component example
 * @enduml
 */
namespace example {

class EXAMPLE_DEPRECATED Base {
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

#endif  // EXAMPLE_DERIVED_HPP_
