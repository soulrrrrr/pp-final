CC = mpicxx
CFLAGS = -O3

solve_md5: solve_md5.o ../md5.o
	$(CC) $(CFLAGS) $^ -o $@

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f ./solve_md5_mpi *.o

.PHONY: clean