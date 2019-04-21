#ifndef EXAMPLE_DERIVED_HPP
#define EXAMPLE_DERIVED_HPP

#include <example/export.h>

/**
 * @startuml
 * component example
 * @enduml
 */
namespace example {

class EXAMPLE_EXPORT Base {
  public:
    virtual ~Base();
    virtual void virtualMethod() = 0;

  protected:
    int protectedMethod() { return ++protectedMember; }
    int protectedMember{0};

  private:
    int privateMethod() { return ++privateMember; }
    int privateMember{0};
};

class EXAMPLE_EXPORT Derived : public Base {
  public:
    void virtualMethod() override;
};

}  // namespace example

#endif  // EXAMPLE_DERIVED_HPP
