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
    int protectedMethod();
    static int protectedMember;

  private:
    EXAMPLE_NO_EXPORT int privateMethod();
    EXAMPLE_NO_EXPORT static const int privateMember{42};
};

class EXAMPLE_EXPORT Derived : public Base {
  public:
    void virtualMethod() override;
};

}  // namespace example

#endif  // EXAMPLE_DERIVED_HPP
