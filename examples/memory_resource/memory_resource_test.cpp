#include <gtest/gtest.h>
#if defined(HAVE_MEMORY_RESOURCE)
#include <memory_resource>
#include <vector>

namespace pmr = std::pmr;
#elif defined(HAVE_EXPERIMENTAL_MEMORY_RESOURCE)
#include <experimental/memory_resource>
#include <experimental/vector>

namespace pmr = std::experimental::pmr;
#endif

namespace memory_resource {
namespace {

using Simple = int;

struct Complex {
    pmr::vector<Simple> simple_list;
};

struct Producer {
    pmr::vector<Complex> produce() {
        return pmr::vector<Complex>{1000, pmr::new_delete_resource()};
    }
};

struct Consumer {
    void consume() { complex_list = producer.produce(); }
    Producer& producer;
    pmr::vector<Complex> complex_list{};
};

TEST(memory_resource, default_null_memory_resource) {
    pmr::set_default_resource(pmr::null_memory_resource());
    Producer producer;
    Consumer consumer{producer};
    EXPECT_THROW(consumer.consume(), std::bad_alloc);
}

TEST(memory_resource, default_new_delete_resource) {
    pmr::set_default_resource(pmr::new_delete_resource());
    Producer producer;
    Consumer consumer{producer};
    EXPECT_NO_THROW(consumer.consume());
}

}  // namespace
}  // namespace memory_resource
