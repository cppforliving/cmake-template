#ifndef EXAMPLE_LOCKABLE_HPP
#define EXAMPLE_LOCKABLE_HPP

#include <mutex>
#include <utility>

#include <example/export.h>

namespace example {

template <typename L>
class Lock {
  public:
    explicit Lock(L& lockable) : m_lockable{lockable} {
        m_lockable.m_mutex.lock();
    }
    Lock(L& lockable, std::adopt_lock_t /*unused*/) noexcept
        : m_lockable(lockable) {}
    ~Lock() { m_lockable.m_mutex.unlock(); }

    Lock(Lock const&) = delete;
    void operator=(Lock const&) = delete;

    typename L::value_type* operator->() noexcept { return &m_lockable.m_data; }
    typename L::value_type const* operator->() const noexcept {
        return &m_lockable.m_data;
    }

    typename L::value_type& operator*() noexcept { return m_lockable.m_data; }
    typename L::value_type const& operator*() const noexcept {
        return m_lockable.m_data;
    }

  private:
    L& m_lockable;
};

template <typename T, typename M = std::mutex>
class Lockable {
  public:
    using value_type = T;

    Lockable() = default;
    ~Lockable() = default;

    template <typename... Args>
    explicit Lockable(Args&&... args) : m_data{std::forward<Args>(args)...} {}

    Lockable(Lockable const&) = delete;
    void operator=(Lockable const&) = delete;

    void lock() { m_mutex.lock(); }
    bool try_lock() noexcept { return m_mutex.try_lock(); }
    void unlock() { m_mutex.unlock(); }

  private:
    friend class Lock<Lockable>;

    T m_data;
    M m_mutex;
};

template <typename T>
explicit Lockable(T)->Lockable<T>;

template <typename T>
using RecursiveLockable = Lockable<T, std::recursive_mutex>;

}  // namespace example

#endif  // EXAMPLE_LOCKABLE_HPP
