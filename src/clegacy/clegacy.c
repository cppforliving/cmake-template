#include "clegacy/clegacy.h"

#include <stdlib.h>

static int get123(void) {
    return 123;
}

static int* newInt(void) {
    return malloc(sizeof(int));
}

int* clegacy_newInt123(void) {
    int* x = newInt();
    *x = get123();
    return x;
}
