build : target/boot/polinx-boot.bin target/polinx.vhd
	dd if=target/boot/polinx-boot.bin of=target/polinx.vhd count=1 bs=510 conv=notrunc

target/boot/polinx-boot.bin:src/boot/linker.ld target/boot/polinx-boot.o target/boot/polinx-boot-lib.o
	ld --oformat binary -o target/boot/polinx-boot.bin target/boot/polinx-boot.o target/boot/polinx-boot-lib.o -T $<

target/boot/polinx-boot.o:src/boot/polinx-boot.s
	as src/boot/polinx-boot.s -o target/boot/polinx-boot.o

target/boot/polinx-boot-lib.o:target/boot/polinx-boot-lib.s
	as target/boot/polinx-boot-lib.s -o target/boot/polinx-boot-lib.o

target/boot/polinx-boot-lib.s:src/boot/polinx-boot-lib.c
	gcc src/boot/polinx-boot-lib.c -S -m16  -o target/boot/polinx-boot-lib.s
target/polinx.vhd:
	cp src/10MB-MBR.vhd target/polinx.vhd

clean:
	rm -rf target/boot/*