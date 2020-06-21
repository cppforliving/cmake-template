#ifndef DERIVED_DERIVED_HPP
#define DERIVED_DERIVED_HPP

#include <examples/export.h>

/// @startuml
/// Base <|-- Derived
/// @enduml
namespace derived {

class EXAMPLES_EXPORT Base {
  public:
    virtual ~Base();
    virtual void virtualMethod() = 0;

  protected:
    int protectedMethod();
    static int protectedMember;

  private:
    EXAMPLES_NO_EXPORT int privateMethod();
    EXAMPLES_NO_EXPORT static int const privateMember{42};
};

class EXAMPLES_EXPORT Derived : public Base {
  public:
    void virtualMethod() override;
};

}  // namespace derived

#endif  // DERIVED_DERIVED_HPP
