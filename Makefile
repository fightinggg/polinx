build :
	cp src/10MB-MBR.vhd target/polinx.vhd
	gcc src/boot/polinx-boot-lib.c -S  -o target/boot/polinx-boot-lib.s
	as src/boot/polinx-boot.s -o target/boot/polinx-boot.o
	as target/boot/polinx-boot-lib.s -o target/boot/polinx-boot-lib.o
	ld -Ttext=0x7c00 --oformat binary -o target/boot/polinx-boot.bin target/boot/polinx-boot.o target/boot/polinx-boot-lib.o
	dd if=target/boot/polinx-boot.bin of=target/polinx.vhd count=1 conv=notrunc