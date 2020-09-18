#include <cassert>
#include <gtest/gtest.h>
#include <optional>
#include <type_traits>
#include <utility>
#if defined(HAVE_MEMORY_RESOURCE)
#include <memory_resource>
#include <string>
#include <vector>

namespace pmr = std::pmr;
#elif defined(HAVE_EXPERIMENTAL_MEMORY_RESOURCE)
#include <experimental/memory_resource>
#include <experimental/string>
#include <experimental/vector>

namespace pmr = std::experimental::pmr;
#endif

#include <finally/finally.hpp>

using testing::Test;

namespace examples {
namespace {

class LoggingMemoryResource : public pmr::memory_resource {
  public:
    explicit LoggingMemoryResource(pmr::memory_resource* const resource) : m_resource{resource} {
        assert(m_resource);
    }

  private:
    void* do_allocate(std::size_t const bytes, std::size_t const align) override {
        void* ptr = nullptr;
        auto const _ = Finally([&] {
            std::cout << "resource " << m_resource << " allocate   " << ptr << " bytes " << bytes
                      << " alignment " << align << '\n';
        });
        ptr = m_resource->allocate(bytes, align);
        return ptr;
    }

    void do_deallocate(void* const ptr, std::size_t const bytes, std::size_t const align) override {
        m_resource->deallocate(ptr, bytes, align);
        std::cout << "resource " << m_resource << " deallocate " << ptr << " bytes " << bytes
                  << " alignment " << align << '\n';
    }

    [[nodiscard]] bool do_is_equal(memory_resource const& other) const noexcept override {
        bool const is_equal = m_resource->is_equal(other);
        std::cout << "resource " << m_resource << " is " << (is_equal ? "    " : "not ") << "equal "
                  << &other << '\n';
        return is_equal;
    }

    pmr::memory_resource* const m_resource;
};

struct Complex {
    using allocator_type = pmr::polymorphic_allocator<std::byte>;
    explicit Complex(allocator_type const& alloc = allocator_type{}) noexcept : name{alloc} {}
    explicit Complex(pmr::string const& a_name, allocator_type const& alloc = allocator_type{})
        : name{a_name, alloc} {}
    Complex(Complex const& other, allocator_type const& alloc = allocator_type{}) : name{alloc} {
        name = other.name;
    }
    Complex(Complex&& other) noexcept : name{std::move(other.name)} {}
    Complex(Complex&& other, allocator_type const& alloc) : name{other.name, alloc} {}
    Complex& operator=(Complex&& other) noexcept {
        name = std::move(other.name);
        return *this;
    }
    Complex& operator=(Complex const& other) = default;
    pmr::string name;
};

static_assert(std::is_nothrow_default_constructible_v<Complex>);
static_assert(std::is_nothrow_destructible_v<Complex>);
static_assert(std::is_nothrow_move_constructible_v<Complex>);
static_assert(std::is_nothrow_move_assignable_v<Complex>);
static_assert(std::is_copy_constructible_v<Complex>);
static_assert(std::is_copy_assignable_v<Complex>);

struct Producer {
    [[nodiscard]] pmr::vector<Complex> produce() const {
        return pmr::vector<Complex>{
            3,
            Complex{{1, 'x', resource}, resource},
            resource,
        };
    }

    pmr::memory_resource* const resource;
};

template<typename F>
bool catch_bad_alloc(F&& f) {
    try {
        std::forward<F>(f)();
    } catch (std::bad_alloc const&) {
        return true;
    }
    return false;
}

struct MemoryResourceTest : Test {
    MemoryResourceTest() {
        pmr::set_default_resource(&null_memory_resource);
    }
    ~MemoryResourceTest() override {
        pmr::set_default_resource(nullptr);
    }

    LoggingMemoryResource null_memory_resource{pmr::null_memory_resource()};
    LoggingMemoryResource new_delete_resource{pmr::new_delete_resource()};

    Producer producer{&new_delete_resource};
};

TEST_F(MemoryResourceTest, default_ctor) {
    EXPECT_FALSE(catch_bad_alloc([] { Complex const complex; }));
}

TEST_F(MemoryResourceTest, move_ctor) {
    Complex complex_1;
    EXPECT_FALSE(catch_bad_alloc([&] { Complex const complex_2{std::move(complex_1)}; }));
}

TEST_F(MemoryResourceTest, polymorphic_return) {
    EXPECT_NO_THROW((void)producer.produce());
}

TEST_F(MemoryResourceTest, polymorphic_move_constructor) {
    EXPECT_FALSE(catch_bad_alloc([&] { auto const complex_list = producer.produce(); }));
}

TEST_F(MemoryResourceTest, polymorphic_move_assignment) {
    pmr::vector<Complex> complex_list;
    EXPECT_THROW(complex_list = producer.produce(), std::bad_alloc);
}

TEST_F(MemoryResourceTest, polymorphic_move_assignment_optional) {
    std::optional<pmr::vector<Complex>> complex_list;
    EXPECT_NO_THROW(complex_list = producer.produce());
}

} // namespace
} // namespace examples
