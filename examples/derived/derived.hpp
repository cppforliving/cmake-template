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
    virtual void virtual_method() = 0;

  protected:
    int protected_method();
    static int protected_member;

  private:
    DERIVED_NO_EXPORT int private_method();
    DERIVED_NO_EXPORT static int const private_member{42};
};

class DERIVED_EXPORT Derived : public Base {
  public:
    void virtual_method() override;
};

} // namespace derived

#endif // DERIVED_DERIVED_HPP
