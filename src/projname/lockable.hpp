#ifndef PROJNAME_LOCKABLE_HPP_
#define PROJNAME_LOCKABLE_HPP_

#include <mutex>
#include <type_traits>
#include <utility>

namespace projname {

template<typename L>
class Lock {
  public:
    explicit Lock(L& lockable) : m_lockable{lockable} {
        m_lockable.m_mutex.lock();
    }
    explicit Lock(L& lockable, std::adopt_lock_t /*unused*/) noexcept : m_lockable{lockable} {}

    Lock() = delete;
    ~Lock() {
        m_lockable.m_mutex.unlock();
    }

    Lock(Lock const&) = delete;
    void operator=(Lock const&) = delete;

    typename L::value_type* operator->() noexcept {
        return &m_lockable.m_value;
    }
    typename L::value_type const* operator->() const noexcept {
        return &m_lockable.m_value;
    }

    typename L::value_type& operator*() noexcept {
        return m_lockable.m_value;
    }
    typename L::value_type const& operator*() const noexcept {
        return m_lockable.m_value;
    }

  private:
    L& m_lockable;
};

template<typename L>
Lock(L&)->Lock<L>;

template<typename L>
Lock(L&, std::adopt_lock_t)->Lock<L>;

template<typename T, typename M>
class Lockable {
    static_assert(std::is_same_v<T, std::decay_t<T>>);

  public:
    using value_type = T;

    explicit Lockable() = default;
    ~Lockable() = default;

    template<typename... Args>
    explicit Lockable(Args&&... args) : m_value{std::forward<Args>(args)...} {}

    Lockable(Lockable const&) = delete;
    void operator=(Lockable const&) = delete;

    void lock() {
        m_mutex.lock();
    }

    [[nodiscard]] bool try_lock() { return m_mutex.try_lock(); }

    void unlock() {
        m_mutex.unlock();
    }

  private:
    friend Lock<Lockable>;

    T m_value;
    M m_mutex;
};

}  // namespace projname

#endif  // PROJNAME_LOCKABLE_HPP_
