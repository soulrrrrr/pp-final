#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "md5.h"

#define MESSAGE_LENGTH 8
#define LIMIT 100000000
#define THREAD_COUNT 1024

int main(int argc, char **argv) {

    // initiate answer
    uint8_t *ans;
    cudaMallocManaged((void**)&ans, sizeof(uint8_t) * 16);
    for (int i = 0; i < 16; i++) {
        char a = argv[1][i * 2];
        char b = argv[1][i * 2 + 1];
        a = (a <= '9') ? a - '0' : (a & 0x7) + 9;
        b = (b <= '9') ? b - '0' : (b & 0x7) + 9;
        ans[i] = (a << 4) + b;
    }

    // uint8_t *d_ans;
    // cudaMallocHost(&d_ans, 16*sizeof(uint8_t));
    // cudaMemcpy(d_ans, ans, 16*sizeof(uint8_t), cudaMemcpyHostToDevice);
    int *val;
    cudaMallocManaged((void**)&val, sizeof(int) * 1); 
    // cudaMalloc(&d_val, 1*sizeof(int));
    int block = (LIMIT / THREAD_COUNT) + 1;
    md5<<<block, THREAD_COUNT>>>(MESSAGE_LENGTH, ans, val);
    cudaDeviceSynchronize();
    // cudaMemcpy(&val, d_val, 1*sizeof(int), cudaMemcpyDeviceToHost);

    printf("The number is %08d\n", *val);

    return 0;
}