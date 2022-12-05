proj: proj.o
	ld -m elf_i386 proj.o -o proj

proj.o: proj.s lib.s
	nasm -f elf proj.s

clean:
	rm -f proj.o
