CC = clang

bin/libnv : cnvlist.c dnvlist.c msgio.c nvlist.c nvpair.c
	mkdir -p bin
	$(CC) -shared -fpic -o $@ -lbsd
