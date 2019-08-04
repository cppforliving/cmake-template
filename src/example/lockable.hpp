#ifndef EXAMPLE_LOCKABLE_HPP
#define EXAMPLE_LOCKABLE_HPP

#include <mutex>
#include <utility>

#include <example/export.h>

namespace example {

template <typename T, typename M = std::mutex>
class Lockable {
  public:
    class Lock {
      public:
        explicit Lock(Lockable& lockable) : m_lockable{lockable} {
            m_lockable.m_mutex.lock();
        }
        Lock(Lockable& lockable, std::adopt_lock_t /*unused*/) noexcept
            : m_lockable(lockable) {}
        ~Lock() { m_lockable.m_mutex.unlock(); }

        Lock(Lock const&) = delete;
        void operator=(Lock const&) = delete;

        T* operator->() noexcept { return &m_lockable.m_data; }
        T const* operator->() const noexcept { return &m_lockable.m_data; }

        T& operator*() noexcept { return m_lockable.m_data; }
        T const& operator*() const noexcept { return m_lockable.m_data; }

      private:
        Lockable& m_lockable;
    };

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
    T m_data;
    M m_mutex;
};

template <typename T>
using RecursiveLockable = Lockable<T, std::recursive_mutex>;

}  // namespace example

#endif  // EXAMPLE_LOCKABLE_HPP
