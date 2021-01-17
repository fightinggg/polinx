build : target/polinx-boot.bin
	dd if=target/polinx-boot.bin of=target/polinx.img count=1 bs=510 conv=notrunc
	echo -e "\x55\xAA" | dd of=target/polinx.img count=1 bs=2 seek=255 conv=notrunc

target/polinx-boot.bin:src/boot/linker.ld target/polinx-boot.o target/polinx-boot-lib.o
	ld --oformat binary -m elf_i386  -o target/polinx-boot.bin target/polinx-boot.o target/polinx-boot-lib.o -T $<

target/polinx-boot.o:src/boot/polinx-boot.s
	as src/boot/polinx-boot.s --32 -c -o target/polinx-boot.o

target/polinx-boot-lib.o:target/polinx-boot-lib.s
	as target/polinx-boot-lib.s --32 -c -o target/polinx-boot-lib.o

target/polinx-boot-lib.s:src/boot/polinx-boot-lib.c
	gcc src/boot/polinx-boot-lib.c -S -m16 -ffreestanding -o target/polinx-boot-lib.s
	
clean:
	rm -rf target/*