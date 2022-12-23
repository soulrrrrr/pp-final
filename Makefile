CC = gcc
CFLAGS = -O3

all:
	$(CC) $(CFLAGS) solve_md5.c -o solve_md5 -lcrypto

clean:
	rm -f ./solve_md5

.PHONY: clean