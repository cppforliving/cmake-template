#include <gtest/gtest.h>
#include <vector>
#if __has_include(<memory_resource>)
#include <memory_resource>
namespace pmr = std::pmr;
#else
#include <experimental/memory_resource>
namespace pmr = std::experimental::pmr;
#endif

namespace memory_resource {
namespace {

using Simple = int;

struct Complex {
    std::pmr::vector<Simple> simple_list;
};

struct Producer {
    std::pmr::vector<Complex> produce() {
        return std::pmr::vector<Complex>{1000, pmr::new_delete_resource()};
    }
};

struct Consumer {
    void consume() { complex_list = producer.produce(); }
    Producer& producer;
    std::pmr::vector<Complex> complex_list{};
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
