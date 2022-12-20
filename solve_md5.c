#include <stdio.h>
#include <stdlib.h>
#include <unistd.h> /* for fork */
#include <sys/types.h> /* for pid_t */
#include <sys/wait.h> /* for wait */
#include <string.h>

#include "md5.h"

#define MESSAGE_LENGTH 8
#define PATH_MAX 1024

int main(int argc, char **argv)
{
    uint8_t hash[16];
    char result[33];
    result[32] = '\0';
    char num[9];
    num[8] = '\0';
    char a = argv[1][0], b = argv[1][1];
    a = (a <= '9') ? a - '0' : (a & 0x7) + 9;
    b = (b <= '9') ? b - '0' : (b & 0x7) + 9;
    uint8_t first_val = (a << 4) + b;
    printf("%u\n", first_val);
    for (int i = 0; i < 100000000; i++)
    {
        sprintf(num, "%08d", i);
        md5(num, MESSAGE_LENGTH, hash);
        if (first_val == hash[0])
        {
            sprintf(
                result,
                "%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                hash[ 0], hash[ 1], hash[ 2], hash[ 3],
                hash[ 4], hash[ 5], hash[ 6], hash[ 7],
                hash[ 8], hash[ 9], hash[10], hash[11],
                hash[12], hash[13], hash[14], hash[15]);
            if (strcmp(result, argv[1]) == 0)
            {
                printf("The number is %d\n", i);
                break;
            }
        }
    }

    return 0;
}