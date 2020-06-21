#ifndef DERIVED_DERIVED_HPP
#define DERIVED_DERIVED_HPP

#include <derived/export.h>

/// @startuml
/// Base <|-- Derived
/// @enduml
namespace derived {

class DERIVED_EXPORT Base {
  public:
    virtual ~Base();
    virtual void virtualMethod() = 0;

  protected:
    int protectedMethod();
    static int protectedMember;

  private:
    DERIVED_NO_EXPORT int privateMethod();
    DERIVED_NO_EXPORT static int const privateMember{42};
};

class DERIVED_EXPORT Derived : public Base {
  public:
    void virtualMethod() override;
};

}  // namespace derived

#endif  // DERIVED_DERIVED_HPP
