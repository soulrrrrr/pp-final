#include <stdio.h>
#include <mpi.h>
#include "../md5.h"

#define MESSAGE_LENGTH 8

#define TAG_NUMBER_FOUND 1

int main(int argc, char **argv) {
    MPI_Init(&argc, &argv);
    double start_time = MPI_Wtime();

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

    int world_rank, world_size;
    MPI_Comm_rank(MPI_COMM_WORLD, &world_rank);
    MPI_Comm_size(MPI_COMM_WORLD, &world_size);

    MPI_Request request;
    MPI_Status status;
    int flag;
    int solve_number;

    MPI_Irecv(&solve_number, 1, MPI_INT, MPI_ANY_SOURCE, TAG_NUMBER_FOUND, MPI_COMM_WORLD, &request);
    MPI_Test(&request, &flag, &status);
    for(int i = world_rank; i < 100000000; i += world_size){
        sprintf(num, "%08d", i);
        md5((unsigned char *)num, MESSAGE_LENGTH, hash);
        if (memcmp(hash, ans, 16) == 0) {
            for(int j = 0; j < world_size; j++){
                MPI_Send(&i, 1, MPI_INT, j, TAG_NUMBER_FOUND, MPI_COMM_WORLD);
            }
        }
        MPI_Test(&request, &flag, &status);
        if(flag)
            break;
    }
    MPI_Barrier(MPI_COMM_WORLD);
    if(world_rank == 0){
        MPI_Test(&request, &flag, &status);
        if(flag)
            printf("The number is %d\n", solve_number);
        double end_time = MPI_Wtime();
        printf("MPI running time: %lf Seconds\n", end_time - start_time);
    }

    MPI_Finalize();
    return 0;
}