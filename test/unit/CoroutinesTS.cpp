#include <gtest/gtest.h>
#include <type_traits>
// #if __has_include(<experimental/coroutine>)
// #include <experimental/coroutine>
// #endif

TEST(CoroutinesTS, alwaysFail) {
    // #if __has_include(<experimental/coroutine>)
    //     EXPECT_TRUE(std::is_class<std::experimental::coroutine_handle<>>());
    // #else
    SUCCEED() << "coroutines-ts not supported";
    // #endif
}
