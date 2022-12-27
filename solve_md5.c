#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>    /* for fork */
#include <sys/types.h> /* for pid_t */
#include <sys/wait.h>  /* for wait */
#include <string.h>

#include <openssl/md5.h>

int main(int argc, char **argv) {
    uint8_t digest[MD5_DIGEST_LENGTH];
    uint8_t ans[MD5_DIGEST_LENGTH];
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

        MD5_CTX context;
        MD5_Init(&context);
        MD5_Update(&context, num, strlen(num));
        MD5_Final(digest, &context);

        if (memcmp(digest, ans, 16) == 0) {
            printf("The number is %08d\n", i);
            break;
        }
    }

    return 0;
}