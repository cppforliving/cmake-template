#ifndef DERIVED_DERIVED_HPP
#define DERIVED_DERIVED_HPP

#include <atomic>
#include <cstdint>

#include <derived/export.h>

namespace derived {

class DERIVED_EXPORT Base {
  public:
    virtual ~Base();
    virtual void virtual_method() = 0;

  protected:
    [[nodiscard]] static std::int32_t protected_method();
    static std::atomic_int32_t PROTECTED_MEMBER;

  private:
    [[nodiscard]] DERIVED_NO_EXPORT static std::int32_t private_method();
    DERIVED_NO_EXPORT static std::int32_t const PRIVATE_MEMBER{42};
};

class DERIVED_EXPORT Derived : public Base {
  public:
    void virtual_method() override;
};

} // namespace derived

#endif // DERIVED_DERIVED_HPP
