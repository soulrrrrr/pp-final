CC = nvcc
CFLAGS = -O3

solve_md5: solve_md5.o md5.o
	$(CC) $(CFLAGS) $^ -o $@

%.o: %.cu
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f ./solve_md5 *.o

.PHONY: clean