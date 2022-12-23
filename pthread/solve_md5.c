#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>    /* for fork */
#include <sys/types.h> /* for pid_t */
#include <sys/wait.h>  /* for wait */
#include <string.h>
#include <pthread.h>
#include <stdbool.h>

#include <openssl/md5.h>

#define MAX_THREAD 4

uint8_t ans[MD5_DIGEST_LENGTH];
bool flag = false;

struct thread_data {
    int start, end;
};

void *thread_func(void *arg) {
    struct thread_data *data = (struct thread_data *)arg;
    int start = data->start;
    int end = data->end;

    uint8_t digest[MD5_DIGEST_LENGTH];
    char num[9];
    num[8] = '\0';

    for (int i = start; i < end; i++) {
        if (flag) return NULL;

        sprintf(num, "%08d", i);

        MD5_CTX context;
        MD5_Init(&context);
        MD5_Update(&context, num, strlen(num));
        MD5_Final(digest, &context);

        if (memcmp(digest, ans, 16) == 0) {
            printf("The number is %08d\n", i);
            flag = true;
            return NULL;
        }
    }

    return NULL;
}

int main(int argc, char **argv) {

    for (int i = 0; i < 16; i++) {
        char a = argv[1][i * 2];
        char b = argv[1][i * 2 + 1];
        a = (a <= '9') ? a - '0' : (a & 0x7) + 9;
        b = (b <= '9') ? b - '0' : (b & 0x7) + 9;
        ans[i] = (a << 4) + b;
    }

    pthread_t threads[MAX_THREAD];
    struct thread_data data[MAX_THREAD];

    int step = 100000000 / MAX_THREAD;

    for (int i = 0; i < MAX_THREAD; i++) {
        data[i].start = i * step;
        data[i].end = (i + 1) * step;
        pthread_create(&threads[i], NULL, thread_func, &data[i]);
    }

    for (int i = 0; i < MAX_THREAD; i++)
        pthread_join(threads[i], NULL);

    return 0;
}