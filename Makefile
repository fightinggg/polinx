build : target/polinx-boot.bin
	dd if=target/polinx-boot.bin of=target/polinx.img count=1 bs=510 conv=notrunc
	echo 55aa | xxd -r -ps | dd of=target/polinx.img count=1 bs=2 seek=255 conv=notrunc

objdasm: target/polinx-boot.o
	objdump -d -s target/polinx-boot.o > target/polinx-boot.objdasm


dasm: target/polinx-boot.bin
	objdump -m i386 -b binary -D target/polinx-boot.bin  > target/polinx-boot.dasm
   


target/polinx-boot.bin:src/boot/linker.ld target/polinx-boot.o target/polinx-boot-lib.o
	ld --oformat binary -m elf_i386  -o target/polinx-boot.bin target/polinx-boot.o target/polinx-boot-lib.o -T $<

target/polinx-boot.o:src/boot/polinx-boot.S
	gcc -fno-builtin -fno-PIC -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Os -nostdinc -c src/boot/polinx-boot.S -o target/polinx-boot.o

target/polinx-boot-lib.o:src/boot/polinx-boot-lib.c
	gcc -fno-builtin -fno-PIC -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Os -nostdinc -c src/boot/polinx-boot-lib.c -o target/polinx-boot-lib.o
	
clean:
	rm -rf target/*