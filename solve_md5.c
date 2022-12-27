#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>    /* for fork */
#include <sys/types.h> /* for pid_t */
#include <sys/wait.h>  /* for wait */
#include <string.h>

#include "md5.h"

#define MESSAGE_LENGTH 8
#define PATH_MAX 1024

int main(int argc, char **argv) {
    uint8_t hash[16];
    uint8_t ans[16];
    char num[9];
    num[8] = '\0';

    for (int i = 0; i < 16; i++) {
        char a = argv[1][i * 2];
        char b = argv[1][i * 2 + 1];
        a = (a <= '9') ? a - '0' : (a & 0x7) + 9;
        b = (b <= '9') ? b - '0' : (b & 0x7) + 9;
        ans[i] = (a << 4) + b;
    }

    for (int i = 0; i < 100000000; i++) {
        sprintf(num, "%08d", i);
        md5(num, MESSAGE_LENGTH, hash);

        if (memcmp(hash, ans, 16) == 0) {
            printf("The number is %08d\n", i);
            break;
        }
    }

    return 0;
}