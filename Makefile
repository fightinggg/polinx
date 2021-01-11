build :
	nasm -f macho32 -o target/boot.o src/asm/polinx-boot.asm 
	nasm -f macho32  -o target/system.o src/asm/polinx.asm
	gcc -m32 target/system.o target/boot.o
	# dd if=target/boot.bin of=target/boot.img bs=512 count=1
	# dd if=target/boot.bin of=target/boot.img bs=512 count=1