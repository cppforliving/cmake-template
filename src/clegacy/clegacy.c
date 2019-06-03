#include "clegacy.h"

#include <stdlib.h>

#include <sqlite3.h>

static int get123(void) {
    return 123;
}

static int* newInt(void) {
    return (int*)malloc(sizeof(int));
}

int* clegacy_newInt123(void) {
    int* x = newInt();
    *x = get123();
    return x;
}

void clegacy_deleteInt123(int* x) {
    free(x);
}
